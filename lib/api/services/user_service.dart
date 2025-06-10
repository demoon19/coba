import 'package:dating/api/models/user_model.dart';
import 'dart:math'; // For simulating random potential matches

class UserService {
  // We'll reuse the local users list from AuthService for consistency
  // In a real local app, this would be a persistent storage solution (e.g., Hive, SQLite)
  static final List<Map<String, dynamic>> _localUsers = [];

  // Method to manually add users for testing (not part of typical app flow)
  static void addLocalUser(UserModel user) {
    _localUsers.add(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final userData = _localUsers.firstWhere(
        (user) => user['id'] == userId,
        orElse: () => {}, // Return an empty map if not found
      );

      if (userData.isNotEmpty) {
        return UserModel.fromMap(userData);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<List<UserModel>> getPotentialMatches(
    String currentUserId, {
    int limit = 10,
  }) async {
    try {
      // Get the current user data (though not strictly needed for this simple local example)
      final currentUser = await getUser(currentUserId);
      if (currentUser == null) return [];

      // Filter out the current user and take a limited number of others
      // In a real app, you'd add more sophisticated matching logic here
      final List<UserModel> potentialMatches = _localUsers
          .where((user) => user['id'] != currentUserId)
          .map((userMap) => UserModel.fromMap(userMap))
          .toList();

      // Simulate random selection or ordering for "potential matches"
      // In a real app, this would involve distance, preferences, etc.
      potentialMatches.shuffle(Random());

      return potentialMatches.take(limit).toList();
    } catch (e) {
      print('Error getting potential matches: $e');
      return [];
    }
  }

  Future<void> updateBalance(String userId, double amount) async {
    try {
      final userIndex = _localUsers.indexWhere((user) => user['id'] == userId);
      if (userIndex != -1) {
        _localUsers[userIndex]['balance'] = (_localUsers[userIndex]['balance'] ?? 0.0) + amount;
        print('Updated balance for $userId: ${_localUsers[userIndex]['balance']}'); // For debugging
      } else {
        throw Exception('User not found to update balance.');
      }
    } catch (e) {
      print('Error updating balance: $e');
      rethrow;
    }
  }

  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final userIndex = _localUsers.indexWhere((user) => user['id'] == userId);
      if (userIndex != -1) {
        // Update specific fields from the data map
        _localUsers[userIndex].addAll(data);
        print('Updated profile for $userId: ${_localUsers[userIndex]}'); // For debugging
      } else {
        throw Exception('User not found to update profile.');
      }
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }
}