import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/layout/app_top_bar.dart';
import '../../../../shared/widgets/layout/screen.dart';
import '../../domain/models/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_date_divider.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_state_view.dart';

final class ChatMessagesPage extends StatefulWidget {
  const ChatMessagesPage({
    required this.chatId,
    required this.repository,
    required this.tokenStorage,
    super.key,
  });

  final String chatId;
  final ChatRepository repository;
  final TokenStorage tokenStorage;

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

final class _ChatMessagesPageState extends State<ChatMessagesPage> {
  late final TextEditingController _messageController;
  late final ScrollController _scrollController;
  late final Timer _pollingTimer;

  List<Message>? _messages;
  String? _currentUserId;
  String? _errorMessage;
  var _isFetching = false;
  var _isSending = false;
  var _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    unawaited(_initialize());
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _refreshMessages(),
    );
  }

  @override
  void dispose() {
    _pollingTimer.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _loadCurrentUserId();
    await _refreshMessages(forceScroll: true);
  }

  Future<void> _loadCurrentUserId() async {
    final session = await widget.tokenStorage.getSession();
    if (session == null) {
      return;
    }

    try {
      final json = jsonDecode(session);
      final user = json is Map ? json['user'] : null;
      final id = user is Map ? user['id'] : null;
      if (id is String && id.isNotEmpty && mounted) {
        setState(() => _currentUserId = id);
      }
    } on FormatException {
      return;
    }
  }

  Future<void> _refreshMessages({bool forceScroll = false}) async {
    if (_isFetching || _isSending || !mounted) {
      return;
    }

    final shouldStayAtBottom = forceScroll || _isNearBottom;
    setState(() => _isFetching = true);
    final result = await widget.repository.getMessages(widget.chatId);
    if (!mounted) {
      return;
    }

    switch (result) {
      case Success<List<Message>>(:final value):
        final messages = [...value]
          ..sort((first, second) => first.createdAt.compareTo(second.createdAt));
        setState(() {
          _messages = messages;
          _errorMessage = null;
          _isFetching = false;
        });
        if (shouldStayAtBottom) {
          _scheduleScrollToBottom();
        }
      case ErrorResult<List<Message>>(:final failure):
        setState(() {
          _errorMessage = failure.statusCode == null
              ? 'Нет подключения к интернету'
              : failure.message;
          _isFetching = false;
        });
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) {
      return true;
    }
    return _scrollController.position.maxScrollExtent -
            _scrollController.position.pixels <=
        AppSpacing.space80;
  }

  void _scheduleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = _messages;

    return Screen(
      padding: EdgeInsets.zero,
      appBar: AppTopBar(title: 'Chat', onBack: () => context.pop()),
      child: Column(
        children: [
          Expanded(
            child: switch ((messages, _errorMessage)) {
              (null, null) => const ChatStateView.loading(),
              (_, final errorMessage?) when messages == null => ChatStateView(
                icon: Icons.wifi_off_outlined,
                title: 'Не удалось загрузить сообщения',
                message: errorMessage,
                onRetry: _refreshMessages,
              ),
              (final values?, _) when values.isEmpty => const ChatStateView(
                icon: Icons.forum_outlined,
                title: 'Сообщений пока нет',
                message: 'Начните диалог — собеседник увидит сообщение сразу.',
              ),
              (final values?, _) => _MessagesList(
                controller: _scrollController,
                messages: values,
                currentUserId: _currentUserId,
              ),
              _ => const ChatStateView.loading(),
            },
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.space20,
                0,
                AppSpacing.space20,
                AppSpacing.space4,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ChatTypingIndicator(),
              ),
            ),
          ChatComposer(
            controller: _messageController,
            isSending: _isSending,
            onChanged: (value) => setState(() => _isTyping = value.isNotEmpty),
            onSubmitted: _sendMessage,
            onSend: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(String value) async {
    final text = value.trim();
    if (text.isEmpty || _isSending) {
      return;
    }

    final pendingMessage = Message(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      orderId: widget.chatId,
      senderId: _currentUserId ?? '',
      text: text,
      createdAt: DateTime.now(),
      deliveryStatus: MessageDeliveryStatus.sending,
    );
    setState(() {
      _messages = [...?_messages, pendingMessage];
      _messageController.clear();
      _isSending = true;
      _isTyping = false;
    });
    _scheduleScrollToBottom();

    final result = await widget.repository.sendMessage(widget.chatId, text);
    if (!mounted) {
      return;
    }

    switch (result) {
      case Success<Message>(:final value):
        setState(() {
          _messages = _messages
              ?.map(
                (message) => message.id == pendingMessage.id
                    ? value.copyWith(deliveryStatus: MessageDeliveryStatus.sent)
                    : message,
              )
              .toList();
          _isSending = false;
        });
        _scheduleScrollToBottom();
      case ErrorResult<Message>(:final failure):
        setState(() {
          _messages = _messages
              ?.where((message) => message.id != pendingMessage.id)
              .toList();
          _isSending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
    }
  }
}

final class _MessagesList extends StatelessWidget {
  const _MessagesList({
    required this.controller,
    required this.messages,
    required this.currentUserId,
  });

  final ScrollController controller;
  final List<Message> messages;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space16,
        AppSpacing.space20,
        AppSpacing.space16,
        AppSpacing.space12,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final previous = index == 0 ? null : messages[index - 1];
        final next = index == messages.length - 1 ? null : messages[index + 1];
        final isMine = message.senderId == currentUserId ||
            message.deliveryStatus == MessageDeliveryStatus.sending;
        final isSameDay = previous != null &&
            previous.createdAt.year == message.createdAt.year &&
            previous.createdAt.month == message.createdAt.month &&
            previous.createdAt.day == message.createdAt.day;
        final isGroupedWithPrevious = previous != null &&
            previous.senderId == message.senderId &&
            isSameDay;
        final isGroupedWithNext = next != null &&
            next.senderId == message.senderId &&
            next.createdAt.year == message.createdAt.year &&
            next.createdAt.month == message.createdAt.month &&
            next.createdAt.day == message.createdAt.day;

        return Column(
          children: [
            if (!isSameDay) ChatDateDivider(date: message.createdAt),
            ChatMessageBubble(
              message: message,
              isMine: isMine,
              isGroupedWithPrevious: isGroupedWithPrevious,
              showAvatar: !isMine && !isGroupedWithNext,
            ),
          ],
        );
      },
    );
  }
}
