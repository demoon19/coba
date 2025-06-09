import 'package:dating/api/models/user_model.dart';
import 'package:dating/api/services/user_service.dart';
import 'package:dating/data/local_storage/session_manager.dart';

class UserRepository {
  final UserService _userService;

  UserRepository({UserService? userService})
    : _userService = userService ?? UserService();

  Future<UserModel?> getCurrentUser() async {
    final userId = SessionManager.getUserId();
    if (userId == null) return null;
    return await _userService.getUser(userId);
  }

  Future<List<UserModel>> getPotentialMatches() async {
    final currentUserId = SessionManager.getUserId();
    if (currentUserId == null) return [];
    return await _userService.getPotentialMatches(currentUserId);
  }

  Future<void> updateBalance(String userId, double amount) async {
    await _userService.updateBalance(userId, amount);
  }

  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await _userService.updateUserProfile(userId, data);
  }

  Future<UserModel?> getUserById(String userId) async {
    return await _userService.getUser(userId);
  }
}
