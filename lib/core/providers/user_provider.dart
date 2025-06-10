import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';
import 'package:dating/data/repositories/user_repository.dart';
import 'package:dating/core/providers/auth_provider.dart'; // Import AuthProvider

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  final UserRepository _userRepository;
  final AuthProvider _authProvider; // For listening to authentication changes

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserProvider(this._userRepository, this._authProvider) {
    // Immediately load user when provider is initialized
    _loadCurrentUser();
    // Listen to authentication status changes
    _authProvider.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    if (_authProvider.isAuthenticated) {
      _loadCurrentUser(); // Reload user if logged in
    } else {
      _currentUser = null; // Clear user if logged out
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
      // Assuming _userRepository.getCurrentUser() now returns UserModel
      // based on local storage (e.g., from SessionManager)
      _currentUser = await _userRepository.getCurrentUser();
    } catch (e) {
      _errorMessage = 'Failed to load user data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to update balance from external sources
  Future<void> updateBalanceInProvider(double amount) async {
    if (_currentUser != null) {
      // Create a new UserModel instance with updated balance
      _currentUser = _currentUser!.copyWith(
        balance: _currentUser!.balance + amount,
      );
      notifyListeners();
      // You should also ensure this is updated in your local storage
      // For instance, by calling a method in _userRepository if applicable
      // await _userRepository.updateBalance(_currentUser!.id, amount);
    }
  }

  // Method to update profile in the provider after UI update
  void updateCurrentUserProfile({
    String? username,
    String? bio,
    String? profileImageUrl,
    Map<String, double>? location,
  }) {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        username: username ?? _currentUser!.username,
        email: _currentUser!.email,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
        bio: bio ?? _currentUser!.bio,
        location:
            location ?? _currentUser!.location, // Now Map<String, double>?
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

// Add copyWith method in UserModel extension for easy updates
extension UserModelCopyWith on UserModel {
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    String? bio,
    Map<String, double>?
    location, // Changed from GeoPoint to Map<String, double>?
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
