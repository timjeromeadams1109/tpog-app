import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/mock/mock_data.dart';
import '../../services/content_service.dart';
import '../../theme/app_colors.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
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

  void _showComingSoon(BuildContext context, MockSermon s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${s.title}" — video coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sermons = MockData.sermons;
    final featured = sermons.first;
    final rest = sermons.sublist(1);

    return Scaffold(
      appBar: AppBar(
        title: Text(_cms.get('vod', 'header.title', fallback: 'Watch')),
        actions: [
          IconButton(icon: const Icon(Icons.live_tv_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _featuredCard(context, featured),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _cms.get('vod', 'live.label', fallback: 'LIVE Sunday 10:00 AM'),
                  style: const TextStyle(
                    color: AppColors.danger,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              _cms.get('vod', 'section.recent', fallback: 'RECENT SERMONS'),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          for (final s in rest) _row(context, s),
        ],
      ),
    );
  }

  Widget _featuredCard(BuildContext context, MockSermon s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showComingSoon(context, s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: s.thumbnailUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black26,
                      alignment: Alignment.center,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.tpogBlue,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.tpogBlue.withValues(alpha: 0.45),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.play_arrow,
                            color: Colors.white, size: 38),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.tpogBlue.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        s.series.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.tpogBlueLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${s.speaker} • ${s.duration} • ${DateFormat('MMM d').format(s.date)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, MockSermon s) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: s.thumbnailUrl,
          width: 100,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        s.title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${s.series} • ${s.duration}',
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      trailing: Text(
        DateFormat('MMM d').format(s.date),
        style: const TextStyle(color: AppColors.textTertiary, fontSize: 11),
      ),
      onTap: () => _showComingSoon(context, s),
    );
  }
}
