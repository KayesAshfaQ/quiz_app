import 'package:flutter/foundation.dart';
import 'package:quiz_app/models/user.dart';
import 'package:quiz_app/services/auth_service.dart';

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
        email: credentials.user?.email ?? '',
      );
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
      );
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
      );

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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? value) {
    _errorMessage = value;
    notifyListeners();
  }
}
