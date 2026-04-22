import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushAll = true;
  bool _pushEvents = true;
  bool _pushMessages = true;
  bool _pushCommunity = false;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _sectionTitle('NOTIFICATIONS'),
          SwitchListTile(
            value: _pushAll,
            activeColor: AppColors.tpogBlue,
            onChanged: (v) => setState(() => _pushAll = v),
            title: const Text('Push notifications'),
            subtitle: const Text('Receive all app notifications'),
          ),
          SwitchListTile(
            value: _pushEvents && _pushAll,
            activeColor: AppColors.tpogBlue,
            onChanged: _pushAll
                ? (v) => setState(() => _pushEvents = v)
                : null,
            title: const Text('Events & services'),
          ),
          SwitchListTile(
            value: _pushMessages && _pushAll,
            activeColor: AppColors.tpogBlue,
            onChanged: _pushAll
                ? (v) => setState(() => _pushMessages = v)
                : null,
            title: const Text('Messages'),
          ),
          SwitchListTile(
            value: _pushCommunity && _pushAll,
            activeColor: AppColors.tpogBlue,
            onChanged: _pushAll
                ? (v) => setState(() => _pushCommunity = v)
                : null,
            title: const Text('Community posts'),
          ),
          _sectionTitle('APPEARANCE'),
          SwitchListTile(
            value: _darkMode,
            activeColor: AppColors.tpogBlue,
            onChanged: (v) => setState(() => _darkMode = v),
            title: const Text('Dark mode'),
          ),
          _sectionTitle('ACCOUNT'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change password'),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy'),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & support'),
            trailing:
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title: const Text('Sign out',
                style: TextStyle(color: AppColors.danger)),
            onTap: () {},
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
