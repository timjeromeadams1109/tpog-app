import 'package:flutter/material.dart';

import '../../services/content_service.dart';
import '../../shared/widgets/time_ago.dart';
import '../../theme/app_colors.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  static final _cms = ContentService.instance;
  final _requests = <_Req>[
    _Req('Sarah Mitchell',
        'Praying for wisdom as we look for a new home for my mother. The stress has been heavy.',
        DateTime.now().subtract(const Duration(hours: 3)),
        7),
    _Req('David Chen',
        'My son is in the middle of college applications. Asking for peace and direction for him.',
        DateTime.now().subtract(const Duration(hours: 8)),
        12),
    _Req('Anonymous',
        'Health update in the family. Asking for healing and that the doctors would know what to do.',
        DateTime.now().subtract(const Duration(days: 1)),
        19),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_cms.get('prayer', 'header.title', fallback: 'Prayer requests'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewRequest,
        backgroundColor: AppColors.tpogBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Request'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _requests.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final r = _requests[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        r.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '• ${timeAgo(r.at)}',
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    r.body,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.favorite,
                          size: 14,
                          color: AppColors.tpogBlue.withValues(alpha: 0.8)),
                      const SizedBox(width: 4),
                      Text(
                        '${r.prayers} praying',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.handshake_outlined, size: 16),
                        label: Text(_cms.get('prayer', 'pray.label', fallback: 'Pray')),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          foregroundColor: AppColors.tpogBlueLight,
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          setState(() => r.prayers += 1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_cms.get('prayer', 'snackbar.pray', fallback: 'Added to your prayer list')),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openNewRequest() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _cms.get('prayer', 'form.title', fallback: 'Prayer request'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: _cms.get('prayer', 'form.hint', fallback: 'How can we pray for you?'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.visibility_off_outlined,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  _cms.get('prayer', 'anonymous.label', fallback: 'Post anonymously'),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                Spacer(),
                Switch(value: false, onChanged: null),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(_cms.get('prayer', 'snackbar.submit', fallback: 'Shared with the prayer team'))),
                );
              },
              child: Text(_cms.get('prayer', 'submit.label', fallback: 'Submit request')),
            ),
          ],
        ),
      ),
    );
  }
}

class _Req {
  final String name;
  final String body;
  final DateTime at;
  int prayers;
  _Req(this.name, this.body, this.at, this.prayers);
}
