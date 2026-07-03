import 'package:flutter/material.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _profileRepository;
  User? _userProfile;
  bool _isLoading = false;

  ProfileProvider({ProfileRepository? profileRepository})
      : _profileRepository = profileRepository ?? ProfileRepository();

  User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

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
}
