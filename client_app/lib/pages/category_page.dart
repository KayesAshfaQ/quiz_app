import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/models/quiz_category.dart';

import '../app_route.dart';
import '../widgets/category_type_widget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<QuizCategory> categories = [
    QuizCategory(
      name: 'Mathematics',
      questionCount: 10,
      icon: Icons.calculate,
      color: Colors.blue,
    ),
    QuizCategory(
      name: 'Science & Nature',
      questionCount: 13,
      icon: Icons.science,
      color: Colors.green,
    ),
    QuizCategory(
      name: 'History',
      questionCount: 12,
      icon: Icons.history,
      color: Colors.orange,
    ),
    QuizCategory(
      name: 'Geography',
      questionCount: 11,
      icon: Icons.map,
      color: Colors.purple,
    ),
    QuizCategory(
      name: 'Sports',
      questionCount: 14,
      icon: Icons.sports_soccer,
      color: Colors.red,
    ),
    QuizCategory(
      name: 'Entertainment',
      questionCount: 15,
      icon: Icons.movie,
      color: Colors.pink,
    ),
    QuizCategory(
      name: 'Art & Literature',
      questionCount: 16,
      icon: Icons.art_track,
      color: Colors.indigo,
    ),
    QuizCategory(
      name: 'Technology',
      questionCount: 17,
      icon: Icons.computer,
      color: Colors.teal,
    ),
    QuizCategory(
      name: 'Music',
      questionCount: 18,
      icon: Icons.music_note,
      color: Colors.yellow,
    ),
    QuizCategory(
      name: 'General Knowledge',
      questionCount: 19,
      icon: Icons.question_answer,
      color: Colors.brown,
    ),
  ];

  List<QuizCategory> _filterCategories(String type) {
    switch (type) {
      case 'Popular':
        return categories
            .where(
              (c) => [
                'Science & Nature',
                'History',
                'Sports',
                'Entertainment',
              ].contains(c.name),
            )
            .toList();
      case 'New':
        return categories
            .where(
              (c) => [
                'Art & Literature',
                'Technology',
                'Music',
                'General Knowledge',
              ].contains(c.name),
            )
            .toList();
      default:
        return categories;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Quiz Categories'),
          automaticallyImplyActions: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'All', icon: Icon(Icons.list)),
              Tab(text: 'Popular', icon: Icon(Icons.star)),
              Tab(text: 'New', icon: Icon(Icons.new_releases)),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.access_time_filled),
              onPressed: () {
                context.push(AppRoute.subscription);
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            CategoryTypeWidget(categories: categories),
            CategoryTypeWidget(categories: _filterCategories('Popular')),
            CategoryTypeWidget(categories: _filterCategories('New')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Manage Quizzes',
          child: const Icon(Icons.add),
          onPressed: () {
            context.push(AppRoute.quizManagement);
          },
        ),
      ),
    );
  }
}
