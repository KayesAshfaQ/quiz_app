import 'package:flutter/material.dart';

class QuizCategory {
  final String name;
  final int questionCount;
  final IconData icon;
  final Color color;

  QuizCategory({
    required this.name,
    required this.questionCount,
    required this.icon,
    required this.color,
  });
}