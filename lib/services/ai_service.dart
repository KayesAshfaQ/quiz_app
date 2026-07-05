import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';

class AiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  AiService() {
    _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-1.5-flash');
    _chat = _model.startChat();
  }

  Stream<GenerateContentResponse> sendMessageStream(String text) {
    return _chat.sendMessageStream(Content.text(text));
  }

  Future<Map<int, String>?> generateExplanationsBatch(
    List<Map<String, dynamic>> wrongAnswers,
  ) async {
    if (wrongAnswers.isEmpty) return {};

    final prompt =
        '''
You are an AI assistant for a quiz app. I will provide a list of wrong answers submitted by a user.
For each item, explain briefly (in 1-2 sentences) why the user's answer is wrong and why the correct one is correct.
Return the result strictly as a JSON object where the keys are the "questionIndex" and the values are the "explanation".

Here is the data:
${wrongAnswers.map((w) => "questionIndex: ${w['index']}, Question: ${w['question']}, User Answer: ${w['selectedAnswer']}, Correct Answer: ${w['correctAnswer']}").join('\n')}
''';

    final jsonModel = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    final response = await jsonModel.generateContent([Content.text(prompt)]);
    final text = response.text;
    if (text != null) {
      try {
        final decoded = jsonDecode(text) as Map<String, dynamic>;
        return decoded.map(
          (key, value) => MapEntry(int.parse(key), value.toString()),
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
