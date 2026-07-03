import 'package:flutter/material.dart';
import 'package:quiz_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:quiz_app/repository/profile_repository.dart';
import 'package:quiz_app/models/scoreboard_entry.dart';
class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  User? _userProfile;
  bool _isLoading = false;

  String _selectedProfileFilter = 'Monthly';
  final List<ScoreboardEntry> _personalHistory = [];
  bool _isLoadingPersonalHistory = false;

  ProfileProvider({
    ProfileRepository? profileRepository,
  })  : _profileRepository = profileRepository ?? ProfileRepository();

  User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String get selectedProfileFilter => _selectedProfileFilter;
  List<ScoreboardEntry> get personalHistory => _personalHistory;
  bool get isLoadingPersonalHistory => _isLoadingPersonalHistory;

  set selectedProfileFilter(String filter) {
    _selectedProfileFilter = filter;
    notifyListeners();
    loadPersonalResults();
  }

  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    _userProfile = await _profileRepository.getUserProfile(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserProfile(User updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    await _profileRepository.updateUserProfile(updatedProfile);
    _userProfile = updatedProfile;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadPersonalResults() async {
    _isLoadingPersonalHistory = true;
    notifyListeners();
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      final results = await _profileRepository.getPersonalResults(
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
}
