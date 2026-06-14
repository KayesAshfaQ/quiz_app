import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/app_route.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/api_client.dart';

class QuizLoadingPage extends StatefulWidget {
  const QuizLoadingPage({super.key});

  @override
  State<QuizLoadingPage> createState() => _QuizLoadingPageState();
}

class _QuizLoadingPageState extends State<QuizLoadingPage> {
  late Future<List<Question>> _questionsFuture;
  final ApiClient _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  void fetchQuestions() {
    setState(() {
      _questionsFuture = _apiClient.fetchTdb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoute.home),
        ),
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading quiz...'),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Failed to load quiz: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: fetchQuestions,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final questions = snapshot.data!;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.replace(AppRoute.quizQuestion, extra: questions);
            });
            return const SizedBox.shrink();
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
