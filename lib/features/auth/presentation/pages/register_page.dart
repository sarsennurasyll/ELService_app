import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../../../shared/widgets/layout/app_top_bar.dart';
import '../../../../shared/widgets/layout/screen.dart';

final class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  var _isCustomer = true;
  var _hasAcceptedTerms = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Aigerim Bekova');
    _phoneController = TextEditingController(text: '+7 700 123 45 67');
    _emailController = TextEditingController(text: 'aigerim@example.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      appBar: AppTopBar(title: '', onBack: () => context.go(AppRoutes.login)),
      bottomNavigationBar: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space24),
            child: PrimaryButton(
              label: 'Create Account',
              onPressed: () {
                // TODO: подключить регистрацию.
              },
            ),
          ),
        ),
      ),
      isScrollable: true,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space24,
          AppSpacing.space8,
          AppSpacing.space24,
          AppSpacing.space24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create account',
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              'Join ELService in under a minute',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSpacing.space24),
            _RoleSelector(
              isCustomer: _isCustomer,
              onCustomerSelected: () => setState(() => _isCustomer = true),
              onTechnicianSelected: () => setState(() => _isCustomer = false),
            ),
            const SizedBox(height: AppSpacing.space20),
            _RegisterForm(
              nameController: _nameController,
              phoneController: _phoneController,
              emailController: _emailController,
            ),
            const SizedBox(height: AppSpacing.space16),
            _TermsAgreement(
              value: _hasAcceptedTerms,
              onChanged: (value) {
                setState(() => _hasAcceptedTerms = value ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

final class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.isCustomer,
    required this.onCustomerSelected,
    required this.onTechnicianSelected,
  });

  final bool isCustomer;
  final VoidCallback onCustomerSelected;
  final VoidCallback onTechnicianSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleCard(
            label: 'Customer',
            isSelected: isCustomer,
            onTap: onCustomerSelected,
          ),
        ),
        const SizedBox(width: AppSpacing.space8),
        Expanded(
          child: _RoleCard(
            label: 'Technician',
            isSelected: !isCustomer,
            onTap: onTechnicianSelected,
          ),
        ),
      ],
    );
  }
}

final class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.selectable,
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'I AM A',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }
}

final class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.nameController,
    required this.phoneController,
    required this.emailController,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: nameController,
          label: 'FULL NAME',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.space12),
        AppTextField(
          controller: phoneController,
          label: 'PHONE NUMBER',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.space12),
        AppTextField(
          controller: emailController,
          label: 'EMAIL',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.space12),
        const AppTextField(
          label: 'PASSWORD',
          isPassword: true,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

final class _TermsAgreement extends StatelessWidget {
  const _TermsAgreement({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        const SizedBox(width: AppSpacing.space8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.space4),
            child: Text.rich(
              TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.mutedForeground,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
