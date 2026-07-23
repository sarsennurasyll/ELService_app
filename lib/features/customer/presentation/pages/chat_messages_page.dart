import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/layout/app_top_bar.dart';
import '../../../../shared/widgets/layout/screen.dart';
import '../../domain/models/message.dart';
import '../../domain/repositories/chat_repository.dart';

final class ChatMessagesPage extends StatefulWidget {
  const ChatMessagesPage({
    required this.chatId,
    required this.repository,
    super.key,
  });

  final String chatId;
  final ChatRepository repository;

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

final class _ChatMessagesPageState extends State<ChatMessagesPage> {
  late Future<Result<List<Message>>> _messagesFuture;
  late final Timer _pollingTimer;
  late final TextEditingController _messageController;
  var _isReloading = false;

  @override
  void initState() {
    super.initState();
    _messagesFuture = _loadMessages();
    _messageController = TextEditingController();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _reload(),
    );
  }

  @override
  void dispose() {
    _pollingTimer.cancel();
    _messageController.dispose();
    super.dispose();
  }

  Future<Result<List<Message>>> _loadMessages() async {
    _isReloading = true;
    final result = await widget.repository.getMessages(widget.chatId);
    _isReloading = false;
    return result;
  }

  void _reload() {
    if (_isReloading || !mounted) {
      return;
    }

    setState(() {
      _messagesFuture = _loadMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      padding: EdgeInsets.zero,
      appBar: AppTopBar(title: 'Chat', onBack: () => context.pop()),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<Result<List<Message>>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final result = snapshot.data;
                if (result is ErrorResult<List<Message>>) {
                  return Center(
                    child: Text(
                      result.failure.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  );
                }
                if (result is Success<List<Message>>) {
                  if (result.value.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.space20),
                    itemCount: result.value.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.space8,
                      ),
                      child: Text(
                        result.value[index].text,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  );
                }

                return const Center(child: Text('Unable to load messages'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space16),
            child: AppTextField(
              controller: _messageController,
              hint: 'Message',
              onSubmitted: _send,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) {
      return;
    }

    await widget.repository.sendMessage(widget.chatId, text.trim());
    _messageController.clear();
    _reload();
  }
}
