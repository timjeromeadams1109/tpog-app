import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class SocialMediaScreen extends StatelessWidget {
  const SocialMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final links = [
      _Link(Icons.language, 'Website', 'placeofgrace.church'),
      _Link(Icons.camera_alt_outlined, 'Instagram', '@tpog_church'),
      _Link(Icons.facebook, 'Facebook', 'The Place of Grace'),
      _Link(Icons.alternate_email, 'Twitter / X', '@tpog'),
      _Link(Icons.play_circle_outline, 'YouTube', 'TPOG Sermons'),
      _Link(Icons.phone_outlined, 'Phone', '(555) 123-4567'),
      _Link(Icons.email_outlined, 'Email', 'hello@placeofgrace.church'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Connect')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: links.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final l = links[i];
          return Card(
            child: ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.tpogBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(l.icon, color: AppColors.tpogBlueLight),
              ),
              title: Text(
                l.label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: Text(
                l.handle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              trailing: const Icon(Icons.open_in_new,
                  size: 18, color: AppColors.textTertiary),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

class _Link {
  final IconData icon;
  final String label;
  final String handle;
  _Link(this.icon, this.label, this.handle);
}
