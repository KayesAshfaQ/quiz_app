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

  factory Question.fromJson(Map<String, dynamic> json) {
    String correctAnswer = json['correct_answer'] as String;
    List<String> incorrectAnswers = List<String>.from(
      json['incorrect_answers'] as List<dynamic>,
    );

    List<String> allOptions = [correctAnswer, ...incorrectAnswers];
    allOptions.shuffle();

    int correctOptionIndex = allOptions.indexOf(correctAnswer);

    int difficulty;
    switch (json['difficulty'] as String) {
      case 'easy':
        difficulty = 1;
        break;
      case 'medium':
        difficulty = 2;
        break;
      case 'hard':
        difficulty = 3;
        break;
      default:
        difficulty = 2; // Default to medium if not specified
    }

    return Question(
      text: json['question'] as String,
      options: allOptions,
      correctOptionIndex: correctOptionIndex,
      difficulty: difficulty,
    );
  }
}
