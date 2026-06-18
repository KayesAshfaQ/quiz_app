import 'question.dart';

class QuizResult {
  final String? id; // Firestore document ID
  final int totalQuestions;
  final int correctCount;
  final int score;
  final List<int?> selectedAnswers; // null = skipped / timed-out
  final List<Question> questions;

  const QuizResult({
    this.id,
    required this.totalQuestions,
    required this.correctCount,
    required this.score,
    required this.selectedAnswers,
    required this.questions,
  });

  double get accuracy =>
      totalQuestions == 0 ? 0 : correctCount / totalQuestions;

  Map<String, dynamic> toFirestore() {
    return {
      'totalQuestions': totalQuestions,
      'correctCount': correctCount,
      'score': score,
      'selectedAnswers': selectedAnswers,
    };
  }

  factory QuizResult.fromFirestore(Map<String, dynamic> data) {
    return QuizResult(
      id: data['id'] as String?,
      totalQuestions: data['totalQuestions'] ?? 0,
      correctCount: data['correctCount'] ?? 0,
      score: data['score'] ?? 0,
      selectedAnswers: List<int?>.from(data['selectedAnswers'] ?? []),
      questions: [], // questions are not stored in Firestore
    );
  }
}
