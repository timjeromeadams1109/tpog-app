import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/mock/mock_data.dart';
import '../../theme/app_colors.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NOTES')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        backgroundColor: AppColors.tpogBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New note'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: MockData.notes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final n = MockData.notes[i];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openDetail(context, n),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (n.sermonRef != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: AppColors.tpogBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          n.sermonRef!,
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.tpogBlueLight,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    Text(
                      n.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      n.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('MMM d, yyyy').format(n.updatedAt),
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, MockNote n) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('NOTE'),
            actions: [
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
              IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (n.sermonRef != null)
                Text(
                  n.sermonRef!,
                  style: const TextStyle(
                    color: AppColors.tpogBlueLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              const SizedBox(height: 6),
              Text(
                n.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat('MMMM d, yyyy').format(n.updatedAt),
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              Text(n.body, style: const TextStyle(fontSize: 15, height: 1.6)),
            ],
          ),
        ),
      ),
    );
  }

  void _openEditor(BuildContext context) {
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
            const Text(
              'New note',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 6,
              decoration: InputDecoration(hintText: 'Start typing…'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note saved')),
                );
              },
              child: const Text('Save note'),
            ),
          ],
        ),
      ),
    );
  }
}
