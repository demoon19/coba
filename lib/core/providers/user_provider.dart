import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';
import 'package:dating/data/repositories/user_repository.dart';
import 'package:dating/core/providers/auth_provider.dart'; // Import AuthProvider

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  final UserRepository _userRepository;
  final AuthProvider _authProvider; // Untuk mendengarkan perubahan autentikasi

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserProvider(this._userRepository, this._authProvider) {
    // Langsung muat user saat provider diinisialisasi
    _loadCurrentUser();
    // Dengarkan perubahan status autentikasi
    _authProvider.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    if (_authProvider.isAuthenticated) {
      _loadCurrentUser(); // Muat ulang user jika login
    } else {
      _currentUser = null; // Kosongkan user jika logout
      notifyListeners();
    }
  }

  Future<void> _loadCurrentUser() async {
    if (!_authProvider.isAuthenticated) {
      _currentUser = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _userRepository.getCurrentUser();
    } catch (e) {
      _errorMessage = 'Failed to load user data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Metode untuk memperbarui saldo dari luar
  Future<void> updateBalanceInProvider(double amount) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(balance: _currentUser!.balance + amount);
      notifyListeners();
      // Anda juga harus memastikan ini diperbarui di Firestore
      // _userRepository.updateBalance(_currentUser!.id, amount); // Panggil ini jika perubahan terjadi di sini
    }
  }

  // Metode untuk memperbarui profil di provider setelah update dari UI
  void updateCurrentUserProfile({String? username, String? bio, String? profileImageUrl, GeoPoint? location}) {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        username: username ?? _currentUser!.username,
        email: _currentUser!.email,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        bio: bio ?? _currentUser!.bio,
        location: location ?? _currentUser!.location,
        balance: _currentUser!.balance,
        createdAt: _currentUser!.createdAt,
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }
}

// Tambahkan copyWith method di UserModel untuk mempermudah update
extension UserModelCopyWith on UserModel {
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    String? bio,
    GeoPoint? location,
    double? balance,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}