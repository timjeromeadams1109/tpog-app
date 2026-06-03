import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock/mock_data.dart';
import '../../services/content_service.dart';
import '../../shared/widgets/avatar.dart';
import '../../theme/app_colors.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  static final _cms = ContentService.instance;

  @override
  void initState() {
    super.initState();
    _cms.contentVersion.addListener(_onCmsUpdate);
  }

  @override
  void dispose() {
    _cms.contentVersion.removeListener(_onCmsUpdate);
    super.dispose();
  }

  void _onCmsUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final me = MockData.me;

    final cms = ContentService.instance;
    final sections = <_MoreSection>[
      _MoreSection(cms.get('more', 'section.life', fallback: 'LIFE AT TPOG'), [
        _MoreItem(Icons.note_alt_outlined,        cms.get('more', 'item.notes',     fallback: 'Notes'),             () => context.go('/notes')),
        _MoreItem(Icons.ondemand_video_outlined,  cms.get('more', 'item.watch',     fallback: 'Watch'),             () => context.go('/watch')),
        _MoreItem(Icons.photo_library_outlined,   cms.get('more', 'item.media',     fallback: 'Media gallery'),     () => context.go('/media')),
        _MoreItem(Icons.calendar_month_outlined,  cms.get('more', 'item.schedule',  fallback: 'My schedule'),       () => context.go('/schedule')),
      ]),
      _MoreSection(cms.get('more', 'section.connect', fallback: 'CONNECT'), [
        _MoreItem(Icons.people_outline,           cms.get('more', 'item.members',   fallback: 'Members directory'), () => context.go('/members')),
        _MoreItem(Icons.volunteer_activism_outlined, cms.get('more', 'item.give',   fallback: 'Give'),              () => context.go('/donate')),
        _MoreItem(Icons.handshake_outlined,       cms.get('more', 'item.prayer',    fallback: 'Prayer requests'),   () => context.go('/requests')),
        _MoreItem(Icons.storefront_outlined,      cms.get('more', 'item.partners',  fallback: 'Local partners'),    () => context.go('/exhibitors')),
      ]),
      _MoreSection(cms.get('more', 'section.account', fallback: 'ACCOUNT'), [
        _MoreItem(Icons.person_outline,           cms.get('more', 'item.profile',   fallback: 'Profile'),           () => context.go('/profile')),
        _MoreItem(Icons.settings_outlined,        cms.get('more', 'item.settings',  fallback: 'Settings'),          () => context.go('/settings')),
        _MoreItem(Icons.share_outlined,           cms.get('more', 'item.social',    fallback: 'Social & website'),  () => context.go('/social')),
        _MoreItem(Icons.logout,                   cms.get('more', 'item.signout',   fallback: 'Sign out'),          () => context.go('/auth/login')),
      ]),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(ContentService.instance.get('more', 'header.title', fallback: 'More'))),
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
          Center(
            child: Text(
              'v1.0.0 • ${ContentService.instance.get('more', 'footer', fallback: 'The Place of Grace')}',
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
