import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/api/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromDocumentSnapshot(doc);
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
      // Ambil data pengguna saat ini untuk filter
      final currentUser = await getUser(currentUserId);
      if (currentUser == null) return [];

      // Contoh query: Ambil pengguna lain yang bukan diri sendiri
      // Anda bisa menambahkan filter lain seperti gender, usia, jarak, dll.
      final querySnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, isNotEqualTo: currentUserId)
          // .where('gender', isEqualTo: 'female') // Contoh filter
          // .orderBy('createdAt', descending: true) // Urutkan berdasarkan waktu pendaftaran
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error getting potential matches: $e');
      return [];
    }
  }

  Future<void> updateBalance(String userId, double amount) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'balance': FieldValue.increment(amount),
      });
    } catch (e) {
      print('Error updating balance: $e');
      rethrow; // Biarkan error ditangani di UI
    }
  }

  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }
}
