import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';
import 'package:dating/api/services/user_service.dart';

class SearchFilterViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String _searchQuery = '';
  int? _minAge;
  int? _maxAge;
  String? _genderFilter;
  // Tambahkan filter lain sesuai kebutuhan (misal: jarak, minat, dll.)

  void setSearchQuery(String query) {
    _searchQuery = query;
    // Debounce search agar tidak terlalu sering memanggil API
    // Future.delayed(Duration(milliseconds: 500), () => performSearch());
  }

  void setAgeFilter(int? min, int? max) {
    _minAge = min;
    _maxAge = max;
  }

  void setGenderFilter(String? gender) {
    _genderFilter = gender;
  }

  Future<void> performSearch() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ini hanya contoh, logika pencarian sebenarnya akan lebih kompleks di Firestore
      // Anda perlu membangun query Firestore dinamis berdasarkan filter
      // Atau, gunakan Firebase Functions untuk pencarian indeks penuh (misal: Algolia/Elasticsearch)
      _searchResults = await _userService.getPotentialMatches('current_user_id_placeholder'); // Perlu ID pengguna

      // Filter di sisi client (untuk demo, di produksi lakukan di Firestore query atau backend)
      _searchResults = _searchResults.where((user) {
        bool matchesQuery = _searchQuery.isEmpty || user.username.toLowerCase().contains(_searchQuery.toLowerCase());
        // Implementasi filter usia
        // Implementasi filter gender
        return matchesQuery;
      }).toList();
    } catch (e) {
      _errorMessage = 'Search failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}