import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../shared/widgets/cards/app_card.dart';

enum _UsersTab { technicians, customers }

final class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

final class _UsersPageState extends State<UsersPage> {
  var _selectedTab = _UsersTab.technicians;
  var _searchQuery = '';
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_UserCardData> get _filteredUsers {
    final source = _selectedTab == _UsersTab.technicians
        ? _technicians
        : _customers;

    if (_searchQuery.trim().isEmpty) {
      return source;
    }

    final query = _searchQuery.trim().toLowerCase();
    return source
        .where((user) => user.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;

    return Column(
      children: [
        _UsersHeader(
          selectedTab: _selectedTab,
          searchController: _searchController,
          onTabSelected: (tab) => setState(() => _selectedTab = tab),
          onSearchChanged: (value) => setState(() => _searchQuery = value),
        ),
        Expanded(
          child: users.isEmpty
              ? Center(
                  child: Text(
                    'No users found',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.space20),
                  itemCount: users.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.space8),
                  itemBuilder: (context, index) =>
                      _UserCard(user: users[index]),
                ),
        ),
      ],
    );
  }
}

final class _UsersHeader extends StatelessWidget {
  const _UsersHeader({
    required this.selectedTab,
    required this.searchController,
    required this.onTabSelected,
    required this.onSearchChanged,
  });

  final _UsersTab selectedTab;
  final TextEditingController searchController;
  final ValueChanged<_UsersTab> onTabSelected;
  final ValueChanged<String> onSearchChanged;

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
              'People',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.space12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.space4),
                child: Row(
                  children: [
                    _UsersTabButton(
                      label: 'TECHNICIANS (486)',
                      isSelected: selectedTab == _UsersTab.technicians,
                      onTap: () => onTabSelected(_UsersTab.technicians),
                    ),
                    _UsersTabButton(
                      label: 'CUSTOMERS (12.8K)',
                      isSelected: selectedTab == _UsersTab.customers,
                      onTap: () => onTabSelected(_UsersTab.customers),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space12),
            SizedBox(
              height: AppSpacing.space40,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search by name',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: AppSpacing.space16,
                      color: AppColors.mutedForeground,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.space8,
                    ),
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

final class _UsersTabButton extends StatelessWidget {
  const _UsersTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : null,
            borderRadius: BorderRadius.circular(AppRadius.large),
            boxShadow: isSelected ? AppShadows.sm : const <BoxShadow>[],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.space8),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.mutedForeground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _UserCard extends StatelessWidget {
  const _UserCard({required this.user});

  final _UserCardData user;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.space12),
      onTap: () {
        // TODO: открыть профиль пользователя.
      },
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
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Center(
                child: Text(
                  user.initials,
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
                    Flexible(
                      child: Text(
                        user.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (user.isVerified) ...[
                      const SizedBox(width: AppSpacing.space4),
                      const Icon(
                        Icons.verified,
                        size: AppSpacing.space12,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.space4),
                Text(
                  user.subtitle,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.mutedForeground,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _UserCardData {
  const _UserCardData({
    required this.name,
    required this.initials,
    required this.subtitle,
    this.isVerified = false,
  });

  final String name;
  final String initials;
  final String subtitle;
  final bool isVerified;
}

const _technicians = [
  _UserCardData(
    name: 'Dmitry Volkov',
    initials: 'DV',
    subtitle: 'Astana · 154 jobs · ★ 4.9',
    isVerified: true,
  ),
  _UserCardData(
    name: 'Arman Serikov',
    initials: 'AS',
    subtitle: 'Astana · 340 jobs · ★ 4.9',
    isVerified: true,
  ),
  _UserCardData(
    name: 'Bauyrzhan Khan',
    initials: 'BK',
    subtitle: 'Almaty · 82 jobs · ★ 4.7',
    isVerified: true,
  ),
  _UserCardData(
    name: 'Alexey Petrov',
    initials: 'AP',
    subtitle: 'Astana · 210 jobs · ★ 4.6',
  ),
];

const _customers = [
  _UserCardData(
    name: 'Aigerim Bekova',
    initials: 'AB',
    subtitle: 'Astana · 12 orders · 184 000 ₸',
  ),
  _UserCardData(
    name: 'Nurlan Tokayev',
    initials: 'NT',
    subtitle: 'Almaty · 8 orders · 132 000 ₸',
  ),
  _UserCardData(
    name: 'Aida Mustafina',
    initials: 'AM',
    subtitle: 'Astana · 5 orders · 68 000 ₸',
  ),
];
