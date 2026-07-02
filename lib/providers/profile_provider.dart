import 'package:flutter/material.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/services/firestore_service.dart';

class ProfileProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  User? _userProfile;
  bool _isLoading = false;

  ProfileProvider(this._firestoreService);

  User? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    _userProfile = await _firestoreService.getUserProfile(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserProfile(User updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    await _firestoreService.updateUserProfile(updatedProfile);
    _userProfile = updatedProfile;

    _isLoading = false;
    notifyListeners();
  }
}
