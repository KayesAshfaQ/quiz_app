import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirestoreService().saveScoreboardEntry(userId, entry);
      }

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

  Future<List<ScoreboardEntry>> loadAllUserResults() async {
    try {
      final results = await FirestoreService().getScoreboardEntries();
      debugPrint('Loaded ${results.length} scoreboard entries for all users');
      return results;
    } catch (e) {
      debugPrint('Error loading all user results: $e');
      return [];
    }
  }

  Future<List<ScoreboardEntry>> loadResults() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final results = await FirestoreService().getScoreboardEntries(id: userId);

    debugPrint('Loaded ${results.length} scoreboard entries for user $userId');
    return results;
  }

  Future<void> deleteResult(String resultId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    try {
      await FirestoreService().deleteScoreboardEntry(userId, resultId);
      await loadHistory(); // Refresh local history after deletion
    } catch (e) {
      debugPrint('Error deleting scoreboard entry: $e');
    }
  }
}
