import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/inputs/app_text_field.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';

final class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.userRepository, super.key});

  final UserRepository userRepository;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final class _ProfilePageState extends State<ProfilePage> {
  late Future<Result<User>> _profileFuture =
      widget.userRepository.getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<User>>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final result = snapshot.data;
        if (result is ErrorResult<User>) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.space64),
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
        if (result is Success<User>) {
          return _ProfileContent(
            user: result.value,
            onEdit: () => _showEditProfile(result.value),
          );
        }

        return const Center(child: Text('Не удалось загрузить профиль'));
      },
    );
  }

  void _showEditProfile(User user) {
    showDialog<void>(
      context: context,
      builder: (context) => _EditProfileDialog(
        user: user,
        userRepository: widget.userRepository,
        onSaved: (updatedUser) {
          setState(() {
            _profileFuture = Future.value(Success(updatedUser));
          });
        },
      ),
    );
  }
}

final class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.user, required this.onEdit});

  final User user;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _ProfileHeader(user: user, onEdit: onEdit),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.space20),
            child: Column(
              children: [
                for (final item in _profileMenuItems) ...[
                  _ProfileMenuItem(item: item),
                  if (item != _profileMenuItems.last)
                    const SizedBox(height: AppSpacing.space8),
                ],
                const SizedBox(height: AppSpacing.space8),
                const _LogOutItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.onEdit});

  final User user;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primary80],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space20,
          AppSpacing.space32,
          AppSpacing.space20,
          AppSpacing.space32,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: AppSpacing.space64,
                  height: AppSpacing.space64,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(
                        alpha: AppColors.primary20.a,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(
                        color: AppColors.surface.withValues(
                          alpha: AppColors.primary30.a,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _initials(user.fullName),
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.surface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space4),
                      Text(
                        user.email,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.surface.withValues(
                            alpha: AppColors.primary80.a,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(
                        alpha: AppColors.primary20.a,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space12,
                        vertical: AppSpacing.space4,
                      ),
                      child: Text(
                        'Edit',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.surface,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space20),
            const _ProfileStatistics(),
          ],
        ),
      ),
    );
  }
}

String _initials(String fullName) {
  return fullName
      .split(' ')
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0])
      .join()
      .toUpperCase();
}

final class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({
    required this.user,
    required this.userRepository,
    required this.onSaved,
  });

  final User user;
  final UserRepository userRepository;
  final ValueChanged<User> onSaved;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

final class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _avatarController;
  late final TextEditingController _cityController;
  String? _errorMessage;
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone);
    _avatarController = TextEditingController(text: widget.user.avatar);
    _cityController = TextEditingController(text: widget.user.city);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _avatarController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: _fullNameController, label: 'FULL NAME'),
            const SizedBox(height: AppSpacing.space12),
            AppTextField(controller: _phoneController, label: 'PHONE'),
            const SizedBox(height: AppSpacing.space12),
            AppTextField(controller: _avatarController, label: 'AVATAR URL'),
            const SizedBox(height: AppSpacing.space12),
            AppTextField(controller: _cityController, label: 'CITY'),
            if (_errorMessage case final errorMessage?) ...[
              const SizedBox(height: AppSpacing.space12),
              Text(
                errorMessage,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        SizedBox(
          width: AppSpacing.space96,
          child: PrimaryButton(
            label: 'Save',
            onPressed: _save,
            isLoading: _isSaving,
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final result = await widget.userRepository.updateCurrentUser(
      fullName: _fullNameController.text.trim(),
      phone: _optionalValue(_phoneController.text),
      avatar: _optionalValue(_avatarController.text),
      city: _optionalValue(_cityController.text),
    );
    if (!mounted) {
      return;
    }

    if (result is ErrorResult<User>) {
      setState(() {
        _isSaving = false;
        _errorMessage = result.failure.message;
      });
      return;
    }
    if (result is Success<User>) {
      widget.onSaved(result.value);
      Navigator.of(context).pop();
    }
  }

  String? _optionalValue(String value) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? null : trimmedValue;
  }
}

final class _ProfileStatistics extends StatelessWidget {
  const _ProfileStatistics();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatisticCard(label: 'ORDERS', value: '12'),
        ),
        SizedBox(width: AppSpacing.space8),
        Expanded(
          child: _StatisticCard(label: 'RATING', value: '4.9'),
        ),
        SizedBox(width: AppSpacing.space8),
        Expanded(
          child: _StatisticCard(label: 'BONUS', value: '₸5k'),
        ),
      ],
    );
  }
}

final class _StatisticCard extends StatelessWidget {
  const _StatisticCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: AppColors.primary10.a),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space12),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.surface,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.surface.withValues(
                  alpha: AppColors.primary80.a,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({required this.item});

  final _ProfileMenuItemData item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: открыть раздел профиля.
      },
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.space40,
            height: AppSpacing.space40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primary10,
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Icon(
                item.icon,
                size: AppSpacing.space20,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Text(
              item.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: AppSpacing.space16,
            color: AppColors.mutedForeground,
          ),
        ],
      ),
    );
  }
}

final class _LogOutItem extends StatelessWidget {
  const _LogOutItem();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () {
        // TODO: подключить выход из аккаунта.
      },
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.space40,
            height: AppSpacing.space40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: AppColors.primary10.a),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: const Icon(
                Icons.logout,
                size: AppSpacing.space20,
                color: AppColors.error,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.space12),
          Expanded(
            child: Text(
              'Log out',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ProfileMenuItemData {
  const _ProfileMenuItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

const _profileMenuItems = [
  _ProfileMenuItemData(icon: Icons.favorite_border, label: 'Favorites'),
  _ProfileMenuItemData(
    icon: Icons.location_on_outlined,
    label: 'Saved addresses',
  ),
  _ProfileMenuItemData(
    icon: Icons.credit_card_outlined,
    label: 'Payment methods',
  ),
  _ProfileMenuItemData(
    icon: Icons.account_balance_wallet_outlined,
    label: 'Promo codes',
  ),
  _ProfileMenuItemData(icon: Icons.settings_outlined, label: 'Settings'),
  _ProfileMenuItemData(icon: Icons.help_outline, label: 'Help center'),
];
