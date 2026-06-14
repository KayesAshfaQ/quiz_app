import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/question.dart';

class ApiClient {
  Future<List<Question>> fetchTdb() async {
    final response = await http.get(
      Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=18&difficulty=medium&type=multiple',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Question> questions = (data['results'] as List)
          .map((json) => Question.fromJson(json))
          .toList();
      print('Fetched ${questions.length} questions from API');
      return questions;
    } else {
      throw Exception('Failed to fetch Tdb data');
    }
  }
}
