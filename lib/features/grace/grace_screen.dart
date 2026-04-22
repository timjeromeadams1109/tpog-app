import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

class GraceScreen extends StatefulWidget {
  const GraceScreen({super.key});

  @override
  State<GraceScreen> createState() => _GraceScreenState();
}

class _GraceScreenState extends State<GraceScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_GraceMessage> _messages = [
    const _GraceMessage(
      fromUser: false,
      body:
          "Hi — I'm Grace, The Place of Grace's AI companion.\n\nI can help with scripture questions, find a sermon, summarize a passage, point you to a small group, or just listen. What's on your heart today?",
    ),
  ];

  static const _suggestions = [
    'Find a sermon on grace',
    'What does Romans 8 mean?',
    'Help me find a small group',
    'Prayer for anxiety',
  ];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_GraceMessage(fromUser: true, body: text.trim()));
      _controller.clear();
      _messages.add(const _GraceMessage(fromUser: false, typing: true));
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _messages.removeLast();
        _messages.add(_GraceMessage(
          fromUser: false,
          body: _mockReply(text),
        ));
      });
      _scrollToBottom();
    });
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

  String _mockReply(String q) {
    final lower = q.toLowerCase();
    if (lower.contains('sermon') || lower.contains('grace')) {
      return 'Two recent sermons touch on grace directly:\n\n**Grace Greater Than** — Pastor Keith, 3 weeks ago, 38 min\n**No Condemnation** (Romans 8) — Pastor Keith, last Sunday, 42 min\n\nWant me to queue the first one in the Watch tab?';
    }
    if (lower.contains('romans 8')) {
      return 'Romans 8 is often called the mountaintop of the New Testament.\n\nThe chapter moves in three movements:\n\n1. **No condemnation (vs 1–4)** — Paul declares the verdict first, before explaining the mechanism.\n2. **Life in the Spirit (vs 5–17)** — our identity shifts from slaves to sons.\n3. **Inseparable love (vs 31–39)** — nothing in all creation can separate us from the love of God.\n\nPastor Keith walked through vs 1–17 last Sunday. Want me to open those notes?';
    }
    if (lower.contains('small group') || lower.contains('group')) {
      return 'There are 10 small groups meeting this season. Three that might fit:\n\n• **Mens Breakfast** — Saturdays 7am, led by David Chen\n• **Young Marrieds** — Thursdays 7pm, led by the Santos family\n• **Grief & Hope** — Tuesdays 6:30pm, by request\n\nWould you like me to send David a note that you\'re interested?';
    }
    if (lower.contains('anxiety') || lower.contains('anxious') ||
        lower.contains('prayer')) {
      return 'I hear you. You aren\'t alone in this.\n\nA prayer for you:\n\n> *Father, You know the weight of this moment. Quiet the noise. Remind us that Your peace is not absence of storm but Your presence within it. In Jesus\' name, amen.*\n\nIf it would help, I can also put in a confidential prayer request with the pastoral team. Just say the word.';
    }
    return 'I\'m here for whatever is on your mind. You can ask about a passage, look for a sermon or group, request prayer, or just think out loud.\n\nIf you\'d rather talk to a pastor, I can also connect you directly.';
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
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.tpogBlue, AppColors.tpogBlueLight],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.tpogBlue.withValues(alpha: 0.5),
                    blurRadius: 12,
                  ),
                ],
              ),
              child:
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GRACE',
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'AI companion • Always here',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.tpogBlueLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
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
          if (_messages.length <= 1) _suggestionsRow(),
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
                  : _renderBody(m.body),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderBody(String body) {
    final spans = <TextSpan>[];
    final parts = body.split('**');
    for (var i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          fontWeight: i.isOdd ? FontWeight.w700 : FontWeight.w400,
          color: AppColors.textPrimary,
          fontSize: 14,
          height: 1.5,
        ),
      ));
    }
    return RichText(text: TextSpan(children: spans));
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
              onSubmitted: _send,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () => _send(_controller.text),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.tpogBlue,
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
  const _GraceMessage({
    required this.fromUser,
    this.body = '',
    this.typing = false,
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
      builder: (_, __) {
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
