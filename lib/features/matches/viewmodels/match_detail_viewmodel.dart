import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';
import 'package:dating/api/models/match_model.dart';
import 'package:dating/data/repositories/user_repository.dart';
import 'package:dating/data/repositories/match_repository.dart';
import 'package:dating/core/providers/auth_provider.dart';

class MatchDetailViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  final MatchRepository _matchRepository;
  final AuthProvider _authProvider; // Untuk mendapatkan currentUserId

  MatchModel? _matchData; // Jika Anda melewati MatchModel
  UserModel? _otherUser; // Profil pengguna yang sedang dilihat
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get otherUser => _otherUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MatchDetailViewModel({
    UserRepository? userRepository,
    MatchRepository? matchRepository,
    required AuthProvider authProvider,
  })  : _userRepository = userRepository ?? UserRepository(),
        _matchRepository = matchRepository ?? MatchRepository(),
        _authProvider = authProvider;

  Future<void> loadMatchAndUser(String otherUserId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ambil profil pengguna lain
      _otherUser = await _userRepository.getUserById(otherUserId);

      if (_otherUser == null) {
        _errorMessage = 'User profile not found.';
        return;
      }

      // Opsional: Jika Anda ingin mendapatkan data MatchModel spesifik
      // Misalnya, jika Anda memiliki MatchModel yang sudah terjadi
      // final currentUserId = _authProvider.currentUserId;
      // if (currentUserId != null) {
      //   final matches = await _matchRepository.getUserMatches(currentUserId);
      //   _matchData = matches.firstWhere(
      //     (match) => (match.userId1 == currentUserId && match.userId2 == otherUserId) ||
      //                 (match.userId2 == currentUserId && match.userId1 == otherUserId),
      //     orElse: () => null, // Jika tidak ada match yang ditemukan
      //   );
      // }

    } catch (e) {
      _errorMessage = 'Failed to load match details: $e';
      print('Error loading match details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String receiverId, String messageContent) async {
    // Implementasi pengiriman pesan
    // Anda perlu layanan chat terpisah untuk ini
    // Misalnya, menyimpan pesan ke koleksi 'messages' di Firestore
    print('Sending message to $receiverId: $messageContent');
    // Implementasi FireStore message send:
    // await FirebaseFirestore.instance.collection('messages').add({
    //   'senderId': _authProvider.currentUserId,
    //   'receiverId': receiverId,
    //   'content': messageContent,
    //   'timestamp': FieldValue.serverTimestamp(),
    // });
    // notifyListeners(); // Atau mungkin hanya memperbarui UI chat
  }

  // Anda bisa menambahkan metode lain seperti:
  // - unmatchUser()
  // - reportUser()
}