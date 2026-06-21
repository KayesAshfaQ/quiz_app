import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/providers/quiz_provider.dart';
import 'package:quiz_app/services/firestore_service.dart';

import '../app_route.dart';

class QuizQuestionPage extends StatefulWidget {
  final List<Question> questions;

  const QuizQuestionPage({super.key, required this.questions});

  @override
  State<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  late QuizProvider _quizProvider;

  @override
  void initState() {
    super.initState();
    _quizProvider = context.read<QuizProvider>();
    _quizProvider.addListener(_onQuizStatusChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _quizProvider.startQuiz(widget.questions);
      print('${widget.questions.length} questions loaded into QuizProvider');
    });
  }

  void _onQuizStatusChanged() {
    if (_quizProvider.status == QuizStatus.finished) {
      if (mounted) {
        context.go(AppRoute.quizResult, extra: _quizProvider.result);
      }
    }
  }

  @override
  void dispose() {
    _quizProvider.removeListener(_onQuizStatusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<QuizProvider>(
      builder: (context, quiz, _) {

        if (quiz.questions.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Question ${quiz.currentIndex + 1} of ${quiz.questions.length}',
            ),
            backgroundColor: colorScheme.inversePrimary,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Chip(
                  avatar: Icon(Icons.star),
                  label: Text(
                    '${quiz.score} pts',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: LinearProgressIndicator(
                  value: quiz.secondsLeft / QuizProvider.totalSeconds,
                  minHeight: 6,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.timer, size: 16),
                            SizedBox(width: 4),
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: Text(
                                '${quiz.secondsLeft} s',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ],
                        ),
                        Chip(
                          label: Text('Easy'),
                          backgroundColor: Colors.green.shade100,
                        ),
                        Text(
                          quiz.currentQuestion.text,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Divider(thickness: 1.5),
                        ...List.generate(quiz.currentQuestion.options.length, (
                          index,
                        ) {
                          return OutlinedButton(
                            onPressed: () {
                              // Handle answer selection
                              quiz.selectedAnswer(index);
                            },
                            child: Text(quiz.currentQuestion.options[index]),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
