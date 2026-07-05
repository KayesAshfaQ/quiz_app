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

  Future<String?> generateExplanation({
    required String question,
    required String selectedAnswer,
    required String correctAnswer,
  }) async {
    final prompt = '''
The user answered "$selectedAnswer" to the question "$question".
The correct answer is "$correctAnswer".
Explain briefly (in 2-3 sentences) why the user's answer is wrong and why the correct one is correct.
''';
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text;
  }
}
