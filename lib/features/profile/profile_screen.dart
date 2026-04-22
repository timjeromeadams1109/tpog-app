import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';
import '../../shared/widgets/avatar.dart';
import '../../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me = MockData.me;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: Avatar(url: me.avatarUrl, fallback: me.name, size: 100)),
          const SizedBox(height: 16),
          Center(
            child: Text(
              me.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          Center(
            child: Text(
              me.role,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _statsRow(),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                _field(Icons.email_outlined, 'Email',
                    'james.wilson@example.com'),
                const Divider(height: 1),
                _field(Icons.phone_outlined, 'Phone', '(555) 123-4567'),
                const Divider(height: 1),
                _field(Icons.cake_outlined, 'Birthday', 'October 14'),
                const Divider(height: 1),
                _field(Icons.home_outlined, 'Small group', 'Mens Breakfast'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'MINISTRIES',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('Audio/Visual')),
              Chip(label: Text('Greeters')),
              Chip(label: Text('Youth Mentor')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _stat('Attending', '4 yrs')),
        Expanded(child: _stat('Posts', '23')),
        Expanded(child: _stat('Groups', '3')),
      ],
    );
  }

  Widget _stat(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.tpogBlueLight,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
