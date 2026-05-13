import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum GraceEventType { meta, sources, token, done, error }

class GraceEvent {
  final GraceEventType type;
  final String? text;
  final String? conversationId;
  final String? errorMessage;
  const GraceEvent({
    required this.type,
    this.text,
    this.conversationId,
    this.errorMessage,
  });
}

class GraceApiService {
  GraceApiService._();
  static final GraceApiService instance = GraceApiService._();

  static const _endpoint = 'https://tpog-web-mockup.vercel.app/api/grace/chat';

  String? _conversationId;

  Stream<GraceEvent> sendMessage(String question) async* {
    final client = http.Client();
    try {
      final request = http.Request('POST', Uri.parse(_endpoint));
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({
        'question': question,
        if (_conversationId != null) 'conversation_id': _conversationId,
        'device_id': 'flutter-app',
      });

      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode != 200) {
        yield const GraceEvent(
          type: GraceEventType.error,
          errorMessage: 'Server error — please try again',
        );
        return;
      }

      String buffer = '';
      String? eventType;
      String? dataLine;

      await for (final chunk
          in streamedResponse.stream.transform(utf8.decoder)) {
        buffer += chunk;
        final lines = buffer.split('\n');
        buffer = lines.removeLast();

        for (final line in lines) {
          if (line.startsWith('event: ')) {
            eventType = line.substring(7).trim();
            dataLine = null;
          } else if (line.startsWith('data: ')) {
            dataLine = line.substring(6).trim();
          } else if (line.isEmpty && eventType != null && dataLine != null) {
            try {
              final data = jsonDecode(dataLine) as Map<String, dynamic>;
              switch (eventType) {
                case 'meta':
                  _conversationId = data['conversation_id'] as String?;
                  yield GraceEvent(
                    type: GraceEventType.meta,
                    conversationId: _conversationId,
                  );
                case 'token':
                  final text = data['text'] as String?;
                  if (text != null) {
                    yield GraceEvent(type: GraceEventType.token, text: text);
                  }
                case 'done':
                  yield const GraceEvent(type: GraceEventType.done);
                case 'sources':
                  yield const GraceEvent(type: GraceEventType.sources);
                case 'error':
                  yield GraceEvent(
                    type: GraceEventType.error,
                    errorMessage: data['message'] as String?,
                  );
              }
            } catch (_) {
              // Malformed SSE data — skip
            }
            eventType = null;
            dataLine = null;
          }
        }
      }
    } catch (e) {
      yield const GraceEvent(
        type: GraceEventType.error,
        errorMessage: 'Connection error — check your internet and try again',
      );
    } finally {
      client.close();
    }
  }

  void resetConversation() {
    _conversationId = null;
  }
}
