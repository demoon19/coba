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

  // Factory constructor for creating a MatchModel from a Map (e.g., from a local database or API)
  factory MatchModel.fromMap(Map<String, dynamic> data) {
    return MatchModel(
      id: data['id'] as String, // Assuming 'id' is present in your local data
      userId1: data['userId1'] as String,
      userId2: data['userId2'] as String,
      matchedAt: DateTime.parse(data['matchedAt'] as String), // Convert String to DateTime
      isSeenByUser1: data['isSeenByUser1'] ?? false,
      isSeenByUser2: data['isSeenByUser2'] ?? false,
      lastMessage: data['lastMessage'] as String?,
      lastMessageAt: data['lastMessageAt'] != null 
          ? DateTime.parse(data['lastMessageAt'] as String) 
          : null, // Convert String to DateTime
    );
  }

  // Convert MatchModel to a Map for storage (e.g., in a local database or sending to an API)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id when converting to map for local storage
      'userId1': userId1,
      'userId2': userId2,
      'matchedAt': matchedAt.toIso8601String(), // Convert DateTime to String
      'isSeenByUser1': isSeenByUser1,
      'isSeenByUser2': isSeenByUser2,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt?.toIso8601String(), // Convert DateTime to String
    };
  }
}