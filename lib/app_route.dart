import 'package:go_router/go_router.dart';
import 'package:quiz_app/models/quiz_result.dart';
import 'package:quiz_app/pages/result_page.dart';
import 'package:quiz_app/pages/scoreboard_page.dart';

import 'pages/home_page.dart';
import 'pages/quiz_management_page.dart';
import 'pages/quiz_question_page.dart';

class AppRoute {
  static const String home = '/home';
  static const String quizQuestion = '/quiz-question';
  static const String quizManagement = '/quiz-management';
  static const String quizResult = '/quiz-result';
  static const String scoreboard = '/scoreboard';

  static final routes = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(path: home, builder: (context, state) => HomePage()),
      GoRoute(
        path: quizQuestion,
        builder: (context, state) => QuizQuestionPage(),
      ),
      GoRoute(
        path: quizManagement,
        builder: (context, state) => QuizManagementPage(),
      ),
      GoRoute(
        path: quizResult,
        builder: (context, state) {
          final result = state.extra as QuizResult;
          return ResultPage(result: result);
        },
      ),
      GoRoute(
        path: AppRoute.scoreboard,
        builder: (context, state) => ScoreboardPage(),
      ),
    ],
  );
}
