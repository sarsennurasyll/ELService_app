import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';

final class ChatComposer extends StatelessWidget {
  const ChatComposer({
    required this.controller,
    required this.isSending,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSend,
    super.key,
  });

  final TextEditingController controller;
  final bool isSending;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.md,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space16,
            AppSpacing.space12,
            AppSpacing.space16,
            AppSpacing.space12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isSending,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.send,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.foreground,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Сообщение',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space16,
                      vertical: AppSpacing.space12,
                    ),
                    filled: true,
                    fillColor: AppColors.muted,
                    border: _border(AppColors.muted),
                    enabledBorder: _border(AppColors.muted),
                    focusedBorder: _border(AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.space8),
              SizedBox(
                width: AppSpacing.space48,
                height: AppSpacing.space48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow: AppShadows.primary,
                  ),
                  child: IconButton(
                    onPressed: isSending ? null : onSend,
                    icon: isSending
                        ? const SizedBox(
                            width: AppSpacing.space20,
                            height: AppSpacing.space20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.surface,
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: AppColors.surface,
                            size: AppSpacing.space20,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.full),
      borderSide: BorderSide(color: color),
    );
  }
}

final class ChatTypingIndicator extends StatelessWidget {
  const ChatTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Печатает…',
      style: AppTextStyles.labelSmall.copyWith(
        color: AppColors.mutedForeground,
        letterSpacing: 0,
      ),
    );
  }
}
