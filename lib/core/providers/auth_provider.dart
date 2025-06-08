import 'package:flutter/material.dart';
import 'package:dating/data/local_storage/session_manager.dart';
import 'package:dating/api/services/auth_service.dart'; // Tambahkan ini

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUserId;
  final AuthService _authService = AuthService(); // Inisialisasi AuthService

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;

  AuthProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    _currentUserId = SessionManager.getUserId();
    _isAuthenticated = _currentUserId != null;
    notifyListeners();
  }

  // Metode login
  Future<bool> login(String email, String password) async {
    final response = await _authService.loginUser(email, password);
    if (response != null && response['success']) {
      _currentUserId = response['userId'];
      await SessionManager.setUserId(_currentUserId!);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    _isAuthenticated = false;
    notifyListeners();
    return false;
  }

  // Metode register (akan otomatis login setelah register)
  Future<bool> register(String email, String password, String username) async {
    final response = await _authService.registerUser(email, password, username);
    if (response != null && response['success']) {
      // Otomatis login setelah registrasi berhasil
      return await login(email, password);
    }
    return false;
  }

  // Metode logout
  Future<void> logout() async {
    await SessionManager.clearSession();
    _currentUserId = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
