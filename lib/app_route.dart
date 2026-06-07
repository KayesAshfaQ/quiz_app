import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/quiz_management_page.dart';
import 'pages/quiz_question_page.dart';

class AppRoute {
  static const String home = '/home';
  static const String quizQuestion = '/quiz-question';
  static const String quizManagement = '/quiz-management';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => HomePage(),
    quizQuestion: (context) => QuizQuestionPage(),
    quizManagement: (context) => QuizManagementPage(),
  };
}
