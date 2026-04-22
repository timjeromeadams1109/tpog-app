import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock/mock_data.dart';
import '../../shared/widgets/avatar.dart';
import '../../theme/app_colors.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me = MockData.me;

    final sections = <_MoreSection>[
      _MoreSection('LIFE AT TPOG', [
        _MoreItem(Icons.note_alt_outlined, 'Notes', () => context.go('/notes')),
        _MoreItem(Icons.ondemand_video_outlined, 'Watch',
            () => context.go('/watch')),
        _MoreItem(Icons.photo_library_outlined, 'Media gallery',
            () => context.go('/media')),
        _MoreItem(Icons.calendar_month_outlined, 'My schedule',
            () => context.go('/schedule')),
      ]),
      _MoreSection('CONNECT', [
        _MoreItem(Icons.people_outline, 'Members directory',
            () => context.go('/members')),
        _MoreItem(Icons.volunteer_activism_outlined, 'Give',
            () => context.go('/donate')),
        _MoreItem(Icons.handshake_outlined, 'Prayer requests',
            () => context.go('/requests')),
        _MoreItem(Icons.storefront_outlined, 'Local partners',
            () => context.go('/exhibitors')),
      ]),
      _MoreSection('ACCOUNT', [
        _MoreItem(Icons.person_outline, 'Profile',
            () => context.go('/profile')),
        _MoreItem(Icons.settings_outlined, 'Settings',
            () => context.go('/settings')),
        _MoreItem(Icons.share_outlined, 'Social & website',
            () => context.go('/social')),
        _MoreItem(Icons.logout, 'Sign out', () => context.go('/auth/login')),
      ]),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: [
          InkWell(
            onTap: () => context.go('/profile'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Row(
                children: [
                  Avatar(url: me.avatarUrl, fallback: me.name, size: 60),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          me.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          me.role,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          for (final section in sections) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                section.title,
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            ...section.items.map(
              (it) => ListTile(
                leading: Icon(it.icon, color: AppColors.textPrimary),
                title: Text(it.label),
                trailing: const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary),
                onTap: it.onTap,
              ),
            ),
            const Divider(height: 1),
          ],
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'v1.0.0 • The Place of Grace',
              style: TextStyle(color: AppColors.textTertiary, fontSize: 11),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _MoreSection {
  final String title;
  final List<_MoreItem> items;
  _MoreSection(this.title, this.items);
}

class _MoreItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  _MoreItem(this.icon, this.label, this.onTap);
}
