import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback onImageTap;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onImageTap,
          child: CircleAvatar(
            radius: 80,
            backgroundImage:
                user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
                ? NetworkImage(user.profileImageUrl!) as ImageProvider
                : const AssetImage(
                    'assets/images/placeholder_profile.png',
                  ), // Pastikan ada gambar ini
            child: user.profileImageUrl == null || user.profileImageUrl!.isEmpty
                ? const Icon(Icons.camera_alt, size: 50, color: Colors.white70)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.username,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
