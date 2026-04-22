import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';
import '../../theme/app_colors.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media'),
        bottom: TabBar(
          controller: _tabs,
          labelColor: AppColors.tpogBlue,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.tpogBlue,
          tabs: const [
            Tab(text: 'Photos'),
            Tab(text: 'Videos'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload to gallery')),
          );
        },
        backgroundColor: AppColors.tpogBlue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_a_photo_outlined),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _grid(MockData.photos, false),
          _grid(MockData.videos, true),
        ],
      ),
    );
  }

  Widget _grid(List<MockMediaItem> items, bool videoOverlay) {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final m = items[i];
        return InkWell(
          onTap: () => _openViewer(m),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: m.url,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppColors.surfaceAlt),
              ),
              if (videoOverlay)
                const Center(
                  child: Icon(Icons.play_circle_filled,
                      color: Colors.white, size: 40),
                ),
            ],
          ),
        );
      },
    );
  }

  void _openViewer(MockMediaItem m) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.download_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: m.url,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
              if (m.isVideo)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.tpogBlue,
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play video'),
                    onPressed: () {},
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  m.caption,
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
