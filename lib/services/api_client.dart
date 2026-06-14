import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/question.dart';

class ApiClient {
  static const String _baseUrl = 'https://opentdb.com/api.php';
  late Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('Requesting: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          print('Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<List<Question>> fetchQuestions({int amount = 10, String difficulty = 'medium'}) async {
    final response = await _dio.get(
      '',
      queryParameters: {
        'amount': amount,
        'difficulty': difficulty,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final List<Question> questions = (data['results'] as List)
          .map((json) => Question.fromJson(json))
          .toList();
      print('Fetched ${questions.length} questions from API');
      return questions;
    } else {
      throw Exception('Failed to fetch questions');
    }
  }


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
