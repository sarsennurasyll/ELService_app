import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

final class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ChatHeader(),
        Expanded(
          child: ListView.separated(
            itemCount: _chats.length,
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemBuilder: (context, index) => _ChatTile(chat: _chats[index]),
          ),
        ),
      ],
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

  final _Chat chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: открыть диалог.
      },
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
                    chat.initials,
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
                          chat.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.foreground,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space8),
                      Text(
                        chat.time,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.mutedForeground,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: AppSpacing.space8),
                        SizedBox(
                          width: AppSpacing.space20,
                          height: AppSpacing.space20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${chat.unreadCount}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
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

final class _Chat {
  const _Chat({
    required this.name,
    required this.initials,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });

  final String name;
  final String initials;
  final String lastMessage;
  final String time;
  final int unreadCount;
}

const _chats = [
  _Chat(
    name: 'Dmitry Volkov',
    initials: 'DV',
    lastMessage: "I'll bring the seal kit.",
    time: '10:08',
    unreadCount: 2,
  ),
  _Chat(
    name: 'ELService Support',
    initials: 'ES',
    lastMessage: 'Your payment receipt has been sent.',
    time: 'Yesterday',
    unreadCount: 0,
  ),
  _Chat(
    name: 'Arman Serikov',
    initials: 'AS',
    lastMessage: 'Thanks for the review!',
    time: 'Mon',
    unreadCount: 0,
  ),
];
