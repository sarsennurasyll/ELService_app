import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/models/chat.dart';
import '../../domain/repositories/chat_repository.dart';

final class ChatPage extends StatefulWidget {
  const ChatPage({required this.repository, super.key});

  final ChatRepository repository;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

final class _ChatPageState extends State<ChatPage> {
  late Future<Result<List<Chat>>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _chatsFuture = widget.repository.getChats();
  }

  void _reloadChats() {
    setState(() {
      _chatsFuture = widget.repository.getChats();
    });
  }

  Future<void> _refreshChats() {
    final chatsFuture = widget.repository.getChats();
    setState(() {
      _chatsFuture = chatsFuture;
    });
    return chatsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ChatHeader(),
        Expanded(
          child: FutureBuilder<Result<List<Chat>>>(
            future: _chatsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              final result = snapshot.data;
              if (result is ErrorResult<List<Chat>>) {
                return _ChatError(
                  message: result.failure.message,
                  onRetry: _reloadChats,
                );
              }

              if (result is Success<List<Chat>>) {
                if (result.value.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refreshChats,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: AppSpacing.space96 * 3),
                        _ChatEmpty(),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshChats,
                  child: ListView.separated(
                    itemCount: result.value.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0),
                    itemBuilder: (context, index) =>
                        _ChatTile(chat: result.value[index]),
                  ),
                );
              }

              return _ChatError(
                message: AppLocalizations.of(context)!.unableToLoadChats,
                onRetry: _reloadChats,
              );
            },
          ),
        ),
      ],
    );
  }
}

final class _ChatError extends StatelessWidget {
  const _ChatError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: AppSpacing.space40,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.space12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.space16),
            SizedBox(
              width: AppSpacing.space96 + AppSpacing.space32,
              child: PrimaryButton(
                label: localizations.retry,
                variant: PrimaryButtonVariant.outline,
                onPressed: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ChatEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.forum_outlined,
              size: AppSpacing.space40,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.space12),
            Text(
              localizations.noChatsYet,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space20,
          AppSpacing.space20,
          AppSpacing.space20,
          AppSpacing.space16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Messages',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.space12),
            SizedBox(
              height: AppSpacing.space32 + AppSpacing.space12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space16,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        size: AppSpacing.space16,
                        color: AppColors.mutedForeground,
                      ),
                      const SizedBox(width: AppSpacing.space12),
                      Text(
                        'Search chats',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.chatMessages(chat.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space20,
          vertical: AppSpacing.space12,
        ),
        child: Row(
          children: [
            SizedBox(
              width: AppSpacing.space48,
              height: AppSpacing.space48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Center(
                  child: Text(
                    'ES',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Order ${chat.orderId}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.foreground,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    chat.lastMessage ?? 'No messages yet',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
