import 'package:flutter/material.dart';

class QuizQuestionPage extends StatelessWidget {
  const QuizQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Question 1 of 10')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Chip(label: Text('Easy'), backgroundColor: Colors.green.shade100),
            Text(
              'What is the capital of France?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Divider(thickness: 1.5),
            OutlinedButton(onPressed: () {}, child: Text('A. Paris')),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('B. London'),
            ),
          ],
        ),
      ),
    );
  }
}
