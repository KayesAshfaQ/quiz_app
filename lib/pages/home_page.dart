import 'package:flutter/material.dart';

import '../widgets/quiz_category_icon.dart';
import 'quiz_question_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Quiz Categories'),
        automaticallyImplyActions: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(
                'Mathematics',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Text('10 Questions'),
              leading: QuizCategoryIcon(icon: Icons.calculate),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to quiz question page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QuizQuestionPage()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                'Science & Nature',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Text('13 Questions'),
              leading: QuizCategoryIcon(
                icon: Icons.science,
                color: Colors.green,
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
