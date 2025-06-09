import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart'; // Perhatikan path yang benar
import 'package:dating/data/repositories/user_repository.dart'; // Import UserRepository
import 'package:dating/core/errors/exceptions.dart'; // Opsional, jika Anda ingin throw exceptions

class SearchFilterViewModel extends ChangeNotifier {
  final UserRepository _userRepository; // Deklarasikan sebagai final, akan diinisialisasi via konstruktor
  // Hapus: final UserService _userService = UserService();

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

  // KONSTRUKTOR YANG DIPERBAIKI:
  // Sekarang menerima UserRepository sebagai argumen posisional
  SearchFilterViewModel(this._userRepository);

  void setSearchQuery(String query) {
    _searchQuery = query;
    // Anda bisa memanggil _performSearch() di sini dengan debounce
    // Contoh debounce:
    // if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    // _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    //   if (_authProvider.currentUserId != null) {
    //     performSearch(_authProvider.currentUserId!);
    //   }
    // });
  }

  void setAgeFilter(int? min, int? max) {
    _minAge = min;
    _maxAge = max;
    notifyListeners(); // Penting jika UI langsung bereaksi terhadap perubahan filter
  }

  void setGenderFilter(String? gender) {
    _genderFilter = gender;
    notifyListeners(); // Penting jika UI langsung bereaksi terhadap perubahan filter
  }

  Future<void> performSearch(String currentUserId) async { // Tambahkan currentUserId sebagai parameter
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Menggunakan UserRepository untuk mendapatkan data
      List<UserModel> allPotentialMatches = await _userRepository.getPotentialMatches();

      // Filter di sisi client (untuk demo). Di produksi, sebaiknya query langsung ke Firestore
      // dengan kombinasi filter yang lebih canggih di repository/service.
      _searchResults = allPotentialMatches.where((user) {
        bool matchesQuery = _searchQuery.isEmpty || user.username.toLowerCase().contains(_searchQuery.toLowerCase());

        // Implementasikan filter usia jika ada data usia di UserModel
        // bool matchesAge = true;
        // if (user.age != null) { // Asumsi UserModel punya properti 'age'
        //   if (_minAge != null && user.age! < _minAge!) matchesAge = false;
        //   if (_maxAge != null && user.age! > _maxAge!) matchesAge = false;
        // }

        // Implementasikan filter gender jika ada data gender di UserModel
        // bool matchesGender = _genderFilter == null || user.gender == _genderFilter;

        // return matchesQuery && matchesAge && matchesGender;
        return matchesQuery; // Kembali ke hanya filter username untuk saat ini
      }).toList();

      if (_searchResults.isEmpty && _searchQuery.isNotEmpty) {
         _errorMessage = 'No users found matching "$_searchQuery".';
      }

    } catch (e) {
      _errorMessage = 'Search failed: ${e.toString()}';
      // Anda bisa throw exception kustom di sini jika ingin error ditangani di UI
      // throw FetchDataException('Search failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}