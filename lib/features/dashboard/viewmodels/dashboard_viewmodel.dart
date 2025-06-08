import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';
import 'package:dating/api/services/user_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

class DashboardViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  List<UserModel> _potentialMatches = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get potentialMatches => _potentialMatches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPotentialMatches(String currentUserId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _potentialMatches = await _userService.getPotentialMatches(currentUserId);
    } catch (e) {
      _errorMessage = 'Failed to load matches: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deductBalanceForSwipe(String userId, double cost) async {
    try {
      final user = await _userService.getUser(userId);
      if (user != null && user.balance >= cost) {
        await _userService.updateBalance(userId, -cost); // Kurangi saldo
        return true;
      }
      return false; // Saldo tidak cukup
    } catch (e) {
      print('Error deducting balance: $e');
      return false;
    }
  }

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final double _shakeThreshold = 10.0; // Ambang batas untuk mendeteksi guncangan

  void startListeningToShake(String currentUserId) {
    if (_accelerometerSubscription != null) return; // Sudah mendengarkan

    _accelerometerSubscription = accelerometerEventStream(samplingPeriod: SensorInterval.normalInterval).listen(
      (AccelerometerEvent event) {
        // Hitung kekuatan guncangan
        double shakeForce = (event.x.abs() + event.y.abs() + event.z.abs()) - 9.8; // Kurangi gravitasi
        if (shakeForce > _shakeThreshold) {
          print("Shake detected! Refreshing matches...");
          // Panggil fungsi untuk refresh data
          fetchPotentialMatches(currentUserId);
          // Optional: Hentikan sebentar agar tidak terlalu sensitif
          _accelerometerSubscription?.pause();
          Future.delayed(const Duration(seconds: 2), () => _accelerometerSubscription?.resume());
        }
      },
    );
  }

  void stopListeningToShake() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  @override
  void dispose() {
    stopListeningToShake();
    super.dispose();
  }
}