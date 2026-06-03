import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart' show darkModeNotifier;
import '../../services/content_service.dart';
import '../../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final _cms = ContentService.instance;
  bool _pushAll = true;
  bool _pushEvents = true;
  bool _pushMessages = true;
  bool _pushCommunity = false;
  bool get _darkMode => darkModeNotifier.value;

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
    return Scaffold(
      appBar: AppBar(title: Text(_cms.get('settings', 'header.title', fallback: 'Settings'))),
      body: ListView(
        children: [
          _sectionTitle(_cms.get('settings', 'section.notifications', fallback: 'NOTIFICATIONS')),
          SwitchListTile(
            value: _pushAll,
            activeColor: AppColors.tpogBlue,
            onChanged: (v) => setState(() => _pushAll = v),
            title: Text(_cms.get('settings', 'notif.all.title', fallback: 'Push notifications')),
            subtitle: Text(_cms.get('settings', 'notif.all.subtitle', fallback: 'Receive all app notifications')),
          ),
          SwitchListTile(
            value: _pushEvents && _pushAll,
            activeColor: AppColors.tpogBlue,
            onChanged: _pushAll
                ? (v) => setState(() => _pushEvents = v)
                : null,
            title: Text(_cms.get('settings', 'notif.events.title', fallback: 'Events & services')),
          ),
          SwitchListTile(
            value: _pushMessages && _pushAll,
            activeColor: AppColors.tpogBlue,
            onChanged: _pushAll
                ? (v) => setState(() => _pushMessages = v)
                : null,
            title: Text(_cms.get('settings', 'notif.messages.title', fallback: 'Messages')),
          ),
          SwitchListTile(
            value: _pushCommunity && _pushAll,
            activeColor: AppColors.tpogBlue,
            onChanged: _pushAll
                ? (v) => setState(() => _pushCommunity = v)
                : null,
            title: Text(_cms.get('settings', 'notif.community.title', fallback: 'Community posts')),
          ),
          _sectionTitle(_cms.get('settings', 'section.appearance', fallback: 'APPEARANCE')),
          SwitchListTile(
            value: _darkMode,
            activeColor: AppColors.tpogBlue,
            onChanged: (v) => setState(() => darkModeNotifier.value = v),
            title: Text(_cms.get('settings', 'appearance.dark.title', fallback: 'Dark mode')),
          ),
          _sectionTitle(_cms.get('settings', 'section.account', fallback: 'ACCOUNT')),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(_cms.get('settings', 'account.password', fallback: 'Change password')),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(_cms.get('settings', 'account.privacy', fallback: 'Privacy')),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(_cms.get('settings', 'account.help', fallback: 'Help & support')),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title: Text(
                _cms.get('settings', 'account.signout', fallback: 'Sign out'),
                style: const TextStyle(color: AppColors.danger)),
            onTap: () => context.go('/auth/login'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
