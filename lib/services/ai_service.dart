import 'package:firebase_ai/firebase_ai.dart';

class AiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  AiService() {
    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.5-flash',
    );
    _chat = _model.startChat();
  }

  Stream<GenerateContentResponse> sendMessageStream(String text) {
    return _chat.sendMessageStream(Content.text(text));
  }
}
