class Question {
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final int difficulty;

  Question({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    this.difficulty = 2,
  });
}
