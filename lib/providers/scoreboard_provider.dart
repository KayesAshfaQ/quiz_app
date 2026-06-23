import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/scoreboard_entry.dart';
import 'package:quiz_app/services/hive_storage_service.dart';

import '../services/firestore_service.dart';

class ScoreboardProvider extends ChangeNotifier {
  final HiveStorageService _storageService;
  List<ScoreboardEntry> _history = [];
  bool _isLoadingHistory = false;

  List<ScoreboardEntry> _globalScores = [];
  bool _isLoadingGlobalScores = false;
  bool _hasMoreGlobalScores = true;
  DocumentSnapshot? _lastDoc;

  ScoreboardProvider(this._storageService);

  List<ScoreboardEntry> get history => _history;
  bool get isLoading => _isLoadingHistory;

  List<ScoreboardEntry> get globalScores => _globalScores;
  bool get isLoadingGlobalScores => _isLoadingGlobalScores;
  bool get hasMoreGlobalScores => _hasMoreGlobalScores;

  Future<void> loadHistory() async {
    _isLoadingHistory = true;
    notifyListeners();
    try {
      _history = await _storageService.getScoreHistory();
    } catch (e) {
      debugPrint('Error loading scoreboard history: $e');
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(ScoreboardEntry entry) async {
    try {
      await _storageService.saveScoreEntry(entry);

      await FirestoreService().saveScoreboardEntry(entry);

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

  Future<List<ScoreboardEntry>> loadPersonalResults() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      final results = await FirestoreService().getUserScoreboard(userId);
      debugPrint(
        'Loaded ${results.length} scoreboard entries for user $userId',
      );
      return results;
    } catch (e) {
      debugPrint('Error loading personal results: $e');
      return [];
    }
  }

  Future<void> fetchNextGlobalPage({bool refresh = false}) async {
    if (_isLoadingGlobalScores) return;
    if (!refresh && !_hasMoreGlobalScores) return;

    if (refresh) {
      _globalScores.clear();
      _lastDoc = null;
      _hasMoreGlobalScores = true;
    }

    _isLoadingGlobalScores = true;
    Future.microtask(() => notifyListeners());

    try {
      final snapshot = await FirestoreService().getGlobalScoreboard(
        _lastDoc,
        10,
      );

      if (snapshot.docs.isNotEmpty) {
        _lastDoc = snapshot.docs.last;
        final newEntry = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Include document ID in the data
          return ScoreboardEntry.fromFirestore(data);
        }).toList();

        _globalScores.addAll(newEntry);
      }

      if (snapshot.docs.length < 10) {
        _hasMoreGlobalScores = false;
      }
    } catch (e) {
      debugPrint('Error fetching global scoreboard: $e');
    } finally {
      _isLoadingGlobalScores = false;
      notifyListeners();
    }
  }

  Future<void> deleteResult(String resultId) async {
    try {
      await FirestoreService().deleteScoreboardEntry(resultId);
      await loadHistory(); // Refresh local history after deletion
    } catch (e) {
      debugPrint('Error deleting scoreboard entry: $e');
    }
  }

  Future<void> onRefreshGlobalScores() async {
    await fetchNextGlobalPage(refresh: true);
  }
}
