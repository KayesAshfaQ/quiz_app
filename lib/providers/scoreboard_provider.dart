import 'package:flutter/material.dart';
import 'package:quiz_app/models/scoreboard_entry.dart';
import 'package:quiz_app/services/hive_storage_service.dart';

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
}
