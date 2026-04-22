import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/mock/mock_data.dart';
import '../../theme/app_colors.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mine = MockData.events.where((e) => e.rsvpd).toList();
    final grouped = <String, List<MockEvent>>{};
    for (final e in MockData.events) {
      final key = DateFormat('EEEE, MMMM d').format(e.startsAt);
      grouped.putIfAbsent(key, () => []).add(e);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('MY SCHEDULE')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (mine.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'GOING',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
            for (final e in mine) _rsvpRow(e, true),
            const SizedBox(height: 20),
          ],
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'UPCOMING',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          for (final entry in grouped.entries) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.tpogBlueLight,
                ),
              ),
            ),
            for (final e in entry.value) _rsvpRow(e, false),
          ],
        ],
      ),
    );
  }

  Widget _rsvpRow(MockEvent e, bool mine) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Text(
                DateFormat('h:mm\na').format(e.startsAt),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: AppColors.border,
              margin: const EdgeInsets.symmetric(horizontal: 14),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    e.location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (mine)
              const Icon(Icons.check_circle,
                  color: AppColors.success, size: 20),
          ],
        ),
      ),
    );
  }
}
