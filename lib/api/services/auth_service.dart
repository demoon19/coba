import 'package:crypto/crypto.dart'; // For password encryption
import 'dart:convert'; // For utf8.encode

class AuthService {
  // Simulate a local "users" collection with an in-memory list of maps
  static final List<Map<String, dynamic>> _localUsers = [];
  static int _nextUserId = 1; // For generating unique local user IDs

  // Function to hash passwords (same as before)
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>?> registerUser(String email, String password, String username) async {
    try {
      final hashedPassword = _hashPassword(password);

      // Check if email is already registered in local storage
      if (_localUsers.any((user) => user['email'] == email)) {
        return {'success': false, 'message': 'Email already registered.'};
      }

      // Prepare new user data for local storage
      final newUser = {
        'id': 'user_${_nextUserId++}', // Generate a simple unique ID
        'username': username,
        'email': email,
        'passwordHash': hashedPassword,
        'createdAt': DateTime.now().toIso8601String(), // Store as ISO 8601 string
        'balance': 50000.0,
        'profileImageUrl': '',
        'bio': '',
        'location': {'latitude': 0.0, 'longitude': 0.0}, // Store location as a Map
      };

      _localUsers.add(newUser); // Add the new user to our local "database"

      print('Registered User: $newUser'); // For debugging
      return {'success': true, 'message': 'Registration successful!'};
    } catch (e) {
      print('Error registering user: $e');
      return {'success': false, 'message': 'Registration failed: $e'};
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final hashedPassword = _hashPassword(password);

      // Find user by email and password hash in local storage
      final user = _localUsers.firstWhere(
        (user) => user['email'] == email && user['passwordHash'] == hashedPassword,
        orElse: () => {}, // Return an empty map if no user is found
      );

      if (user.isNotEmpty) {
        // User found, return success and user data
        return {'success': true, 'message': 'Login successful!', 'userId': user['id'], 'userData': user};
      } else {
        // No matching user
        return {'success': false, 'message': 'Invalid email or password.'};
      }
    } catch (e) {
      print('Error logging in user: $e');
      return {'success': false, 'message': 'Login failed: $e'};
    }
  }
}