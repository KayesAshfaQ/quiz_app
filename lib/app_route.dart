import 'package:go_router/go_router.dart';

import 'pages/home_page.dart';
import 'pages/quiz_management_page.dart';
import 'pages/quiz_question_page.dart';

class AppRoute {
  static const String home = '/home';
  static const String quizQuestion = '/quiz-question';
  static const String quizManagement = '/quiz-management';

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
    ],
  );
}
