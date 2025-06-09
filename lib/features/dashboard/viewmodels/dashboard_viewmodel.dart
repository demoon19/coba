import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';
import 'package:dating/data/repositories/user_repository.dart';
import 'package:dating/core/errors/exceptions.dart'; // Import exceptions
import 'package:dating/config/app_constants.dart'; // Import AppConstants

class DashboardViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  List<UserModel> _potentialMatches = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get potentialMatches => _potentialMatches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DashboardViewModel(this._userRepository);

  Future<void> fetchPotentialMatches(String currentUserId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _potentialMatches = await _userRepository.getPotentialMatches();
    } catch (e) {
      _errorMessage = 'Failed to load matches: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deductBalanceForSwipe(String userId, double cost) async {
    try {
      final user = await _userRepository.getUserById(userId);
      if (user != null && user.balance >= cost) {
        await _userRepository.updateBalance(userId, -cost); // Kurangi saldo
        return true;
      }
      throw InsufficientBalanceException('Not enough balance to view profile.');
    } on InsufficientBalanceException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Error deducting balance: ${e.toString()}';
      print('Error deducting balance: $e');
      return false;
    }
  }
}