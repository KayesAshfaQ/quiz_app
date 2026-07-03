import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
          debugPrint('Requesting: ${options.method} ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint('Error: ${e.message}');
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
      debugPrint('Fetched ${questions.length} questions from API');
      return questions;
    } else {
      throw Exception('Failed to fetch questions');
    }
  }


  Future<List<Question>> fetchTdb() async {
    final response = await _dio.get(
      '',
      queryParameters: {
        'amount': 10,
        'category': 18,
        'difficulty': 'medium',
        'type': 'multiple',
      },
    );

    if (response.statusCode == 200) {
      final List<Question> questions = (response.data['results'] as List)
          .map((json) => Question.fromJson(json))
          .toList();
      debugPrint('Fetched ${questions.length} questions from API');
      return questions;
    } else {
      throw Exception('Failed to fetch Tdb data');
    }
  }
}
