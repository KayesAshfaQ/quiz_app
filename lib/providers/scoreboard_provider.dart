import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz_result.dart';
import 'package:quiz_app/models/scoreboard_entry.dart';
import 'package:quiz_app/services/hive_storage_service.dart';

import '../services/firestore_service.dart';

class ScoreboardProvider extends ChangeNotifier {
  final HiveStorageService _storageService;
  List<ScoreboardEntry> _history = [];
  bool _isLoading = false;

  ScoreboardProvider(this._storageService);

  List<ScoreboardEntry> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      _history = await _storageService.getScoreHistory();
    } catch (e) {
      debugPrint('Error loading scoreboard history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(ScoreboardEntry entry) async {
    try {
      await _storageService.saveScoreEntry(entry);
      await loadHistory();
    } catch (e) {
      debugPrint('Error saving scoreboard entry: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      await _storageService.clearScoreHistory();
      _history = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing scoreboard history: $e');
    }
  }

  Future<List<QuizResult>> loadResults() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final results = await FirestoreService().getQuizResults(userId);

    debugPrint('Loaded ${results.length} quiz results for user $userId');
    return results;
  }

  Future<void> deleteResult(String resultId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    try {
      await FirestoreService().deleteQuizResult(userId, resultId);
      await loadHistory(); // Refresh local history after deletion
    } catch (e) {
      debugPrint('Error deleting quiz result: $e');
    }
  }
}
