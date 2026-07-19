import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/layout/screen.dart';

final class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space24,
          AppSpacing.space56,
          AppSpacing.space24,
          AppSpacing.space24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(),
            const SizedBox(height: AppSpacing.space32),
            const _CredentialsForm(),
            const SizedBox(height: AppSpacing.space24),
            PrimaryButton(
              label: 'Sign In',
              onPressed: () {
                // TODO: подключить авторизацию.
              },
            ),
            const SizedBox(height: AppSpacing.space12),
            const _SocialDivider(),
            const SizedBox(height: AppSpacing.space12),
            const Row(
              children: [
                Expanded(
                  child: _SocialSignInButton(icon: Icons.phone_outlined),
                ),
                SizedBox(width: AppSpacing.space8),
                Expanded(child: _SocialSignInButton(icon: Icons.mail_outline)),
                SizedBox(width: AppSpacing.space8),
                Expanded(child: _SocialSignInButton(icon: Icons.apple)),
              ],
            ),
            const Spacer(),
            Text.rich(
              TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedForeground,
                ),
                children: [
                  const TextSpan(text: "Don't have an account? "),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: () => context.go(AppRoutes.register),
                      child: Text(
                        'Create Account',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

final class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back',
          style: AppTextStyles.displayMedium.copyWith(
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: AppSpacing.space4),
        Text(
          'Sign in to continue to ELService',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

final class _CredentialsForm extends StatelessWidget {
  const _CredentialsForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTextField(
          label: 'EMAIL',
          hint: 'email@example.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.space16),
        const AppTextField(
          label: 'PASSWORD',
          isPassword: true,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.space8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // TODO: подключить восстановление пароля.
            },
            child: Text(
              'Forgot Password',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final class _SocialDivider extends StatelessWidget {
  const _SocialDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space12),
          child: Text(
            'OR',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

final class _SocialSignInButton extends StatelessWidget {
  const _SocialSignInButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.space32 + AppSpacing.space12,
      child: OutlinedButton(
        onPressed: () {
          // TODO: подключить вход через внешний сервис.
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
        ),
        child: Icon(
          icon,
          size: AppSpacing.space16,
          color: AppColors.foreground,
        ),
      ),
    );
  }
}
