import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/scoreboard_entry.dart';
import 'package:quiz_app/repository/scoreboard_repository.dart';

class ScoreboardProvider extends ChangeNotifier {
  final ScoreboardRepository _repository;

  final List<ScoreboardEntry> _history = [];
  bool _isLoadingHistory = false;
  bool _hasMoreGlobalScores = true;
  DocumentSnapshot? _lastDoc;
  String _selectedScoreboardFilter = 'all';
  String _selectedProfileFilter = 'Monthly';
  final List<ScoreboardEntry> _personalHistory = [];
  bool _isLoadingPersonalHistory = false;

  ScoreboardProvider({ScoreboardRepository? repository})
      : _repository = repository ?? ScoreboardRepository();

  List<ScoreboardEntry> get history => _history;
  bool get isLoading => _isLoadingHistory;
  bool get hasMoreGlobalScores => _hasMoreGlobalScores;
  String get selectedScoreboardFilter => _selectedScoreboardFilter;
  String get selectedProfileFilter => _selectedProfileFilter;
  
  set selectedProfileFilter(String filter) {
    _selectedProfileFilter = filter;
    notifyListeners();
    loadPersonalResults();
  }
  
  set selectedScoreboardFilter(String filter) {
    _selectedScoreboardFilter = filter;
    notifyListeners();
    loadHistory(refresh: true);
  }

  List<ScoreboardEntry> get personalHistory => _personalHistory;
  bool get isLoadingPersonalHistory => _isLoadingPersonalHistory;

  Future<void> loadHistory({bool refresh = false}) async {
    try {
      fetchNextGlobalPage(refresh: refresh);
    } catch (e) {
      debugPrint('Error loading scoreboard history: $e');
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<void> addEntry(ScoreboardEntry entry) async {
    try {
      await _repository.addEntry(entry);
      await loadHistory();
    } catch (e) {
      debugPrint('Error saving scoreboard entry: $e');
    }
  }

  Future<void> loadPersonalResults() async {
    _isLoadingPersonalHistory = true;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      final results = await _repository.getPersonalResults(
        userId,
        _selectedProfileFilter,
      );
      debugPrint(
        'Loaded ${results.length} scoreboard entries for user $userId with filter $selectedProfileFilter',
      );
      _personalHistory.clear();
      _personalHistory.addAll(results);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading personal results: $e');
    } finally {
      _isLoadingPersonalHistory = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextGlobalPage({bool refresh = false}) async {
    if (_isLoadingHistory) return;
    if (!refresh && !_hasMoreGlobalScores) return;

    if (refresh) {
      _history.clear();
      _lastDoc = null;
      _hasMoreGlobalScores = true;
    }

    _isLoadingHistory = true;
    Future.microtask(() => notifyListeners());

    try {
      final result = await _repository.getGlobalScoreboard(
        _lastDoc,
        10,
        _selectedScoreboardFilter,
      );

      if (result.entries.isNotEmpty) {
        _lastDoc = result.lastDoc;
        _history.addAll(result.entries);
      }

      if (result.entries.length < 10) {
        _hasMoreGlobalScores = false;
      }
    } catch (e) {
      debugPrint('Error fetching global scoreboard: $e');
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<void> deleteResult(String resultId) async {
    try {
      await _repository.deleteResult(resultId);
      await loadHistory(); // Refresh local history after deletion
    } catch (e) {
      debugPrint('Error deleting scoreboard entry: $e');
    }
  }

  Future<void> onRefreshGlobalScores() async {
    await fetchNextGlobalPage(refresh: true);
  }
}
