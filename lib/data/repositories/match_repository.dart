import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/api/api_constants.dart';
import 'package:dating/api/models/match_model.dart';

class MatchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MatchModel>> getUserMatches(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(ApiConstants.matchesCollection)
          .where('userId1', isEqualTo: userId)
          .where('userId2', isEqualTo: userId) // Ini tidak akan bekerja dengan OR
          .get();

      // Perlu query yang lebih kompleks untuk mendapatkan matches di mana userId1 ATAU userId2 adalah userId
      // Cara yang lebih baik adalah dengan 2 query dan menggabungkan hasilnya, atau membuat indeks komposit di Firestore
      // Untuk demo, kita akan melakukan 2 query:
      final matchesAsUser1 = await _firestore
          .collection(ApiConstants.matchesCollection)
          .where('userId1', isEqualTo: userId)
          .get();

      final matchesAsUser2 = await _firestore
          .collection(ApiConstants.matchesCollection)
          .where('userId2', isEqualTo: userId)
          .get();

      final allMatchesDocs = [...matchesAsUser1.docs, ...matchesAsUser2.docs];
      final uniqueMatches = allMatchesDocs.map((doc) => MatchModel.fromDocumentSnapshot(doc)).toList();

      // Hapus duplikat jika ada (jika match dibuat dua kali, atau jika logika Anda membuatnya begitu)
      final seenMatchIds = <String>{};
      final filteredUniqueMatches = <MatchModel>[];
      for (var match in uniqueMatches) {
        if (!seenMatchIds.contains(match.id)) {
          filteredUniqueMatches.add(match);
          seenMatchIds.add(match.id);
        }
      }

      return filteredUniqueMatches;

    } catch (e) {
      print('Error getting user matches: $e');
      return [];
    }
  }

  Future<void> markMatchAsSeen(String matchId, String currentUserId) async {
    try {
      // Tandai match sebagai sudah dilihat oleh pengguna tertentu
      final docRef = _firestore.collection(ApiConstants.matchesCollection).doc(matchId);
      final matchDoc = await docRef.get();
      if (matchDoc.exists) {
        final data = matchDoc.data() as Map<String, dynamic>;
        if (data['userId1'] == currentUserId) {
          await docRef.update({'isSeenByUser1': true});
        } else if (data['userId2'] == currentUserId) {
          await docRef.update({'isSeenByUser2': true});
        }
      }
    } catch (e) {
      print('Error marking match as seen: $e');
    }
  }

  // Anda bisa menambahkan metode untuk membuat match baru jika logika match ada di frontend
  // Namun, biasanya match dibuat di backend setelah ada like bersama
  Future<void> createMatch(String userId1, String userId2) async {
    try {
      // Pastikan tidak ada match duplikat
      final existingMatches = await _firestore.collection(ApiConstants.matchesCollection)
          .where('userId1', isEqualTo: userId1)
          .where('userId2', isEqualTo: userId2)
          .get();
      
      final existingMatchesReversed = await _firestore.collection(ApiConstants.matchesCollection)
          .where('userId1', isEqualTo: userId2)
          .where('userId2', isEqualTo: userId1)
          .get();

      if (existingMatches.docs.isEmpty && existingMatchesReversed.docs.isEmpty) {
        await _firestore.collection(ApiConstants.matchesCollection).add({
          'userId1': userId1,
          'userId2': userId2,
          'matchedAt': FieldValue.serverTimestamp(),
          'isSeenByUser1': false,
          'isSeenByUser2': false,
        });
      }
    } catch (e) {
      print('Error creating match: $e');
      rethrow;
    }
  }
}