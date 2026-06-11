import 'question.dart';

class QuizResult {
  final int totalQuestions;
  final int correctCount;
  final int score;
  final List<int?> selectedAnswers; // null = skipped / timed-out
  final List<Question> questions;

  const QuizResult({
    required this.totalQuestions,
    required this.correctCount,
    required this.score,
    required this.selectedAnswers,
    required this.questions,
  });

  double get accuracy =>
      totalQuestions == 0 ? 0 : correctCount / totalQuestions;
}
