import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;

  const ProfileCard({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user.profileImageUrl != null &&
                  user.profileImageUrl!.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      user.profileImageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, size: 100),
                    ),
                  ),
                )
              else
                const Center(
                  child: Icon(Icons.person, size: 100, color: Colors.grey),
                ),
              const SizedBox(height: 16),
              Text(
                user.username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (user.bio != null && user.bio!.isNotEmpty)
                Text(
                  user.bio!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 18, color: Colors.grey),
                  const SizedBox(width: 4),
                  // Anda bisa menampilkan jarak di sini menggunakan geolocator
                  // Contoh: Text('5 km away')
                  Text(
                    'Location: ${user.location?.latitude.toStringAsFixed(2)}, ${user.location?.longitude.toStringAsFixed(2)}',
                  ),
                ],
              ),
              // Tambahkan info lain seperti minat, usia, dll.
            ],
          ),
        ),
      ),
    );
  }
}
