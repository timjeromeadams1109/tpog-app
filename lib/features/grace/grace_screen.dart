import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/content_service.dart';
import '../../services/grace_api_service.dart';
import '../../theme/app_colors.dart';

class GraceScreen extends StatefulWidget {
  const GraceScreen({super.key});

  @override
  State<GraceScreen> createState() => _GraceScreenState();
}

class _GraceScreenState extends State<GraceScreen> {
  static final _cms = ContentService.instance;

  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isStreaming = false;
  StreamSubscription<GraceEvent>? _subscription;

  List<_GraceMessage> get _initialMessages => [
        _GraceMessage(
          fromUser: false,
          body: _cms.get('chat', 'welcome',
              fallback:
                  "Hi — I'm Grace, The Place of Grace's AI companion.\n\nI can help with scripture questions, find a sermon, summarize a passage, point you to a small group, or just listen. What's on your heart today?"),
        ),
      ];

  late final List<_GraceMessage> _messages = _initialMessages;

  List<String> get _suggestions => [
        _cms.get('chat', 'suggestion.1', fallback: 'Find a sermon on grace'),
        _cms.get('chat', 'suggestion.2', fallback: 'What does Romans 8 mean?'),
        _cms.get('chat', 'suggestion.3', fallback: 'Help me find a small group'),
        _cms.get('chat', 'suggestion.4', fallback: 'Prayer for anxiety'),
      ];

  @override
  void initState() {
    super.initState();
    _cms.contentVersion.addListener(_onCmsUpdate);
  }

  @override
  void dispose() {
    _cms.contentVersion.removeListener(_onCmsUpdate);
    _subscription?.cancel();
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onCmsUpdate() {
    if (mounted) setState(() {});
  }

  void _send(String text) {
    if (text.trim().isEmpty || _isStreaming) return;
    final question = text.trim();
    setState(() {
      _messages.add(_GraceMessage(fromUser: true, body: question));
      _controller.clear();
      _messages.add(const _GraceMessage(fromUser: false, typing: true, body: ''));
      _isStreaming = true;
    });
    _scrollToBottom();

    String accumulated = '';
    final api = GraceApiService.instance;

    _subscription?.cancel();
    _subscription = api.sendMessage(question).listen(
      (event) {
        if (!mounted) return;
        switch (event.type) {
          case GraceEventType.token:
            accumulated += event.text ?? '';
            setState(() {
              _messages[_messages.length - 1] =
                  _GraceMessage(fromUser: false, body: accumulated);
            });
            _scrollToBottom();
          case GraceEventType.done:
            setState(() => _isStreaming = false);
          case GraceEventType.error:
            setState(() {
              _messages[_messages.length - 1] = _GraceMessage(
                fromUser: false,
                body: event.errorMessage ??
                    'Something went wrong. Please try again.',
                isError: true,
              );
              _isStreaming = false;
            });
          case GraceEventType.meta:
          case GraceEventType.sources:
            break;
        }
      },
      onError: (e) {
        if (!mounted) return;
        setState(() {
          _messages[_messages.length - 1] = const _GraceMessage(
            fromUser: false,
            body: 'Connection error. Please check your internet and try again.',
            isError: true,
          );
          _isStreaming = false;
        });
      },
      onDone: () {
        if (!mounted) return;
        setState(() => _isStreaming = false);
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Grace',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'AI companion • Always here',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'New conversation',
            onPressed: _isStreaming
                ? null
                : () {
                    GraceApiService.instance.resetConversation();
                    setState(() {
                      _messages.clear();
                      _messages.addAll(_initialMessages);
                    });
                  },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _messageWidget(_messages[i]),
            ),
          ),
          if (_messages.length <= 1 && !_isStreaming) _suggestionsRow(),
          _composer(),
        ],
      ),
    );
  }

  Widget _messageWidget(_GraceMessage m) {
    if (m.fromUser) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.tpogBlue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  m.body,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.tpogBlue, AppColors.tpogBlueLight],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: AppColors.border),
              ),
              child: m.typing
                  ? const _TypingDots()
                  : _renderBody(m.body, isError: m.isError),
            ),
          ),
        ],
      ),
    );
  }

  static const _churchBaseUrl = 'https://theplaceofgrace.church';

  Future<void> _openLink(String href) async {
    final uri = Uri.tryParse(
      href.startsWith('/') ? '$_churchBaseUrl$href' : href,
    );
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _renderBody(String body, {bool isError = false}) {
    if (isError) {
      return Text(
        body,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
          height: 1.5,
        ),
      );
    }
    return MarkdownBody(
      data: body,
      onTapLink: (text, href, title) {
        if (href != null && href.isNotEmpty) _openLink(href);
      },
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          height: 1.5,
        ),
        strong: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        a: const TextStyle(
          color: AppColors.tpogBlue,
          fontSize: 14,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.tpogBlue,
        ),
        blockquoteDecoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          border: const Border(
            left: BorderSide(color: AppColors.tpogBlue, width: 3),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _suggestionsRow() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final s in _suggestions)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(s),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                  backgroundColor: AppColors.surfaceAlt,
                  side: const BorderSide(color: AppColors.border),
                  onPressed: () => _send(s),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _composer() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
        color: AppColors.tpogDark,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Ask Grace anything…',
                isDense: true,
              ),
              onSubmitted: _isStreaming ? null : _send,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: const Icon(Icons.arrow_upward),
            onPressed: _isStreaming ? null : () => _send(_controller.text),
            style: IconButton.styleFrom(
              backgroundColor: _isStreaming
                  ? AppColors.tpogBlue.withValues(alpha: 0.5)
                  : AppColors.tpogBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _GraceMessage {
  final bool fromUser;
  final String body;
  final bool typing;
  final bool isError;
  const _GraceMessage({
    required this.fromUser,
    this.body = '',
    this.typing = false,
    this.isError = false,
  });
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_c.value - i * 0.2) % 1.0;
            final opacity = (0.3 + (phase < 0.5 ? phase * 2 : (1 - phase) * 2) * 0.7)
                .clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: AppColors.tpogBlueLight.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
