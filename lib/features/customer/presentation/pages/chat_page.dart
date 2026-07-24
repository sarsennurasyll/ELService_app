import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
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
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.space32),
                    child: Text(
                      result.failure.message,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                );
              }

              if (result is Success<List<Chat>>) {
                if (result.value.isEmpty) {
                  return const Center(child: Text('No chats yet'));
                }

                return ListView.separated(
                  itemCount: result.value.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                  ),
                  itemBuilder: (context, index) => _ChatTile(
                    chat: result.value[index],
                  ),
                );
              }

              return const Center(child: Text('Unable to load chats'));
            },
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
