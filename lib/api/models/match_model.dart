import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String userId1; // ID pengguna pertama
  final String userId2; // ID pengguna kedua
  final DateTime matchedAt; // Waktu terjadinya match
  final bool isSeenByUser1; // Apakah pengguna 1 sudah melihat match ini
  final bool isSeenByUser2; // Apakah pengguna 2 sudah melihat match ini
  final String? lastMessage; // Pesan terakhir di chat (jika ada chat)
  final DateTime? lastMessageAt; // Waktu pesan terakhir

  MatchModel({
    required this.id,
    required this.userId1,
    required this.userId2,
    required this.matchedAt,
    this.isSeenByUser1 = false,
    this.isSeenByUser2 = false,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory MatchModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchModel(
      id: doc.id,
      userId1: data['userId1'] as String,
      userId2: data['userId2'] as String,
      matchedAt: (data['matchedAt'] as Timestamp).toDate(),
      isSeenByUser1: data['isSeenByUser1'] ?? false,
      isSeenByUser2: data['isSeenByUser2'] ?? false,
      lastMessage: data['lastMessage'] as String?,
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId1': userId1,
      'userId2': userId2,
      'matchedAt': Timestamp.fromDate(matchedAt),
      'isSeenByUser1': isSeenByUser1,
      'isSeenByUser2': isSeenByUser2,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt != null ? Timestamp.fromDate(lastMessageAt!) : null,
    };
  }
}