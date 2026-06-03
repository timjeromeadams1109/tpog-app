import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';
import '../../services/content_service.dart';
import '../../shared/widgets/avatar.dart';
import '../../shared/widgets/time_ago.dart';
import '../../theme/app_colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  static final _cms = ContentService.instance;
  late final List<MockPost> _posts = List.of(MockData.posts);
  final TextEditingController _composerController = TextEditingController();

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_cms.get('community', 'header.title', fallback: 'Community'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openComposer,
        backgroundColor: AppColors.tpogBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_outlined),
        label: Text(_cms.get('community', 'fab.label', fallback: 'Post')),
      ),
      body: RefreshIndicator(
        onRefresh: () async => Future.delayed(const Duration(milliseconds: 600)),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) => _postCard(_posts[i]),
        ),
      ),
    );
  }

  Widget _postCard(MockPost post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Avatar(
                    url: post.author.avatarUrl,
                    fallback: post.author.name,
                    size: 44,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${post.author.role} • ${timeAgo(post.postedAt)}',
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz,
                        color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                post.body,
                style: const TextStyle(fontSize: 14.5, height: 1.45),
              ),
            ),
            if (post.imageUrl != null)
              CachedNetworkImage(
                imageUrl: post.imageUrl!,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            const Divider(height: 1),
            Row(
              children: [
                _action(
                  icon: post.liked ? Icons.favorite : Icons.favorite_outline,
                  label: '${post.likes}',
                  color: post.liked ? AppColors.tpogBlue : null,
                  onTap: () => setState(() {
                    post.liked = !post.liked;
                    post.likes += post.liked ? 1 : -1;
                  }),
                ),
                _action(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.comments.length}',
                  onTap: () => _openComments(post),
                ),
                _action(
                  icon: Icons.share_outlined,
                  label: _cms.get('community', 'action.share', fallback: 'Share'),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _action({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color ?? AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openComposer() {
    // Clear any previous draft before opening.
    _composerController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _cms.get('community', 'composer.title', fallback: 'New post'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _composerController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: _cms.get('community', 'composer.hint', fallback: 'Share with the community…'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: () {},
                  color: AppColors.textSecondary,
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {},
                  color: AppColors.textSecondary,
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    final text = _composerController.text.trim();
                    Navigator.pop(modalContext);
                    if (text.isNotEmpty) {
                      setState(() {
                        _posts.insert(
                          0,
                          MockPost(
                            id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                            author: MockData.me,
                            body: text,
                            postedAt: DateTime.now(),
                          ),
                        );
                      });
                      _composerController.clear();
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_cms.get('community', 'snackbar.post', fallback: 'Posted to the community'))),
                    );
                  },
                  child: Text(_cms.get('community', 'composer.submit', fallback: 'Post')),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _openComments(MockPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        builder: (_, scrollCtrl) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _cms.get('community', 'comments.title', fallback: 'Comments'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(16),
                itemCount: post.comments.length,
                itemBuilder: (context, i) {
                  final c = post.comments[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Avatar(
                          url: c.author.avatarUrl,
                          fallback: c.author.name,
                          size: 36,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceAlt,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.author.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(c.body),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, left: 8),
                                child: Text(
                                  timeAgo(c.postedAt),
                                  style: const TextStyle(
                                    color: AppColors.textTertiary,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: _cms.get('community', 'comment.hint', fallback: 'Add a comment…'),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.tpogBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
