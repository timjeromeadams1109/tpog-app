import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';
import '../../shared/widgets/avatar.dart';
import '../../theme/app_colors.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final filtered = MockData.users
        .where((u) => u.name.toLowerCase().contains(_q.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('MEMBERS')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search members',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _q = v),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 80,
                color: AppColors.border,
              ),
              itemBuilder: (context, i) {
                final u = filtered[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  leading: Avatar(url: u.avatarUrl, fallback: u.name, size: 44),
                  title: Text(
                    u.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  subtitle: Text(
                    u.role,
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.chat_bubble_outline,
                        color: AppColors.tpogBlueLight),
                    onPressed: () {},
                  ),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
