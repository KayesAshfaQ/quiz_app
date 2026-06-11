import 'package:hive/hive.dart';

part 'scoreboard_entry.g.dart';

@HiveType(typeId: 0)
class ScoreboardEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryName;

  @HiveField(2)
  final int correctCount;

  @HiveField(3)
  final int totalQuestions;

  @HiveField(4)
  final DateTime timestamp;

  ScoreboardEntry({
    required this.id,
    required this.categoryName,
    required this.correctCount,
    required this.totalQuestions,
    required this.timestamp,
  });

  double get accuracy => totalQuestions == 0 ? 0.0 : correctCount / totalQuestions;
}
