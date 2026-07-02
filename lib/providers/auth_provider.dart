import 'package:flutter/foundation.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _user;
  User? get user => _user;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  Future<void> signup(String email, String password) async {
    _setLoading(true);
    try {
      final credentials = await _authService.signup(email, password);
      _user = User(
        uid: credentials.user?.uid ?? '',
        displayName: credentials.user?.email?.split(
          '@',
        )[0], // Use the part before '@' as display name
        email: credentials.user?.email ?? '',
        createdAt: DateTime.now(),
      );

      await FirestoreService().saveUserProfile(_user!);

      debugPrint('User signed up: ${_user?.uid}');
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final credentials = await _authService.login(email, password);
      _user = User(
        uid: credentials.user?.uid ?? '',
        email: credentials.user?.email ?? '',
        displayName: credentials.user?.email?.split(
          '@',
        )[0], // Use the part before '@' as display name
      );

      await FirestoreService().saveUserProfile(_user!);

      debugPrint('User logged in: ${_user?.uid}');
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loginWithGoogle() async {
    _setLoading(true);
    try {
      final credentials = await _authService.loginWithGoogle();
      _user = User(
        uid: credentials?.user?.uid ?? '',
        email: credentials?.user?.email ?? '',
        displayName: credentials?.user?.email?.split(
          '@',
        )[0], // Use the part before '@' as display name
      );

      await FirestoreService().saveUserProfile(_user!);

      debugPrint('User logged in with Google: ${_user?.uid}');
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = null;
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /* Future<void> loadUserProfile(String uid) async {
    _setLoading(true);
    try {
      final userProfile = await FirestoreService().getUserProfile(uid);
      if (userProfile != null) {
        _user = userProfile;
        notifyListeners();
        debugPrint('User profile loaded: ${_user?.uid}');
      } else {
        debugPrint('No user profile found for UID: ${_user?.uid}');
      }
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  } */

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }
}
