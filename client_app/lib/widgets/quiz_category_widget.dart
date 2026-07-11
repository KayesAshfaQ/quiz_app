import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/app_route.dart';

import '../models/quiz_category.dart';
import 'quiz_category_icon.dart';

class QuizCategoryWidget extends StatelessWidget {
  const QuizCategoryWidget({super.key, required this.category});

  final QuizCategory category;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          context.read<QuizProvider>().setCategoryName(category.name);
          context.push(AppRoute.quizLoading);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QuizCategoryIcon(icon: category.icon, color: category.color),
              SizedBox(height: 12),
              Hero(
                tag: 'category-${category.name}',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text('${category.questionCount} Questions'),
            ],
          ),
        ),
      ),
    );
  }
}
