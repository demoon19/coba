class UserModel {
  final String id;
  final String username;
  final String email;
  final String? profileImageUrl;
  final String? bio;
  final Map<String, dynamic>? location; // Representing geographical location
  final double balance;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.profileImageUrl,
    this.bio,
    this.location,
    required this.balance,
    required this.createdAt,
  });

  // Factory constructor for creating a UserModel from a Map (e.g., from local storage or API)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] as String,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'] as String?,
      bio: data['bio'] as String?,
      location: data['location'] as Map<String, dynamic>?, // Assuming location is stored as a Map
      balance: (data['balance'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(data['createdAt'] as String), // Convert String to DateTime
    );
  }

  // Convert UserModel to a Map for storage (e.g., in local database or sending to an API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'location': location,
      'balance': balance,
      'createdAt': createdAt.toIso8601String(), // Convert DateTime to String
    };
  }
}