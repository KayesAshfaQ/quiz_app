import 'package:flutter/material.dart';
import 'package:quiz_app/pages/quiz_question_page.dart';

import '../models/quiz_category.dart';
import 'quiz_category_icon.dart';

class QuizCategoryWidget extends StatelessWidget {
  const QuizCategoryWidget({super.key, required this.category});

  final QuizCategory category;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          category.name,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text('${category.questionCount} Questions'),
        leading: QuizCategoryIcon(icon: category.icon, color: category.color),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizQuestionPage()),
          );
        },
      ),
    );
  }
}
