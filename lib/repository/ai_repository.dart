import 'package:firebase_ai/firebase_ai.dart';
import 'package:quiz_app/services/ai_service.dart';

class AiRepository {
  final AiService aiService;

  AiRepository({required this.aiService});

  Stream<GenerateContentResponse> sendMessageStream(String text) {
    return aiService.sendMessageStream(text);
  }
}
