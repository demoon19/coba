import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart'; // Untuk enkripsi password (contoh)
import 'dart:convert'; // Untuk utf8.encode

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk mengenkripsi password sederhana (hanya contoh, gunakan metode yang lebih kuat di produksi)
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // data being hashed
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>?> registerUser(String email, String password, String username) async {
    try {
      final hashedPassword = _hashPassword(password);

      // Cek apakah email sudah terdaftar
      final querySnapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return {'success': false, 'message': 'Email already registered.'};
      }

      // Simpan data pengguna ke Firestore
      await _firestore.collection('users').add({
        'username': username,
        'email': email,
        'passwordHash': hashedPassword, // Simpan hash password
        'createdAt': FieldValue.serverTimestamp(),
        'balance': 50000.0, // Saldo awal
        'profileImageUrl': '', // Placeholder
        'bio': '',
        'location': const GeoPoint(0, 0), // Placeholder lokasi
      });
      return {'success': true, 'message': 'Registration successful!'};
    } catch (e) {
      print('Error registering user: $e');
      return {'success': false, 'message': 'Registration failed: $e'};
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final hashedPassword = _hashPassword(password);

      // Cari pengguna berdasarkan email dan password hash
      final querySnapshot = await _firestore.collection('users')
          .where('email', isEqualTo: email)
          .where('passwordHash', isEqualTo: hashedPassword)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final userId = querySnapshot.docs.first.id;
        // Simpan sesi (misal: userId) ke penyimpanan lokal
        // Nanti kita akan gunakan SessionManager
        return {'success': true, 'message': 'Login successful!', 'userId': userId, 'userData': userData};
      } else {
        return {'success': false, 'message': 'Invalid email or password.'};
      }
    } catch (e) {
      print('Error logging in user: $e');
      return {'success': false, 'message': 'Login failed: $e'};
    }
  }
}