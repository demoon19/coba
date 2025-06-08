import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';
// Jika ingin menampilkan peta kecil di sini
// Jika ingin menampilkan peta kecil di sini

class MatchDetailScreen extends StatelessWidget {
  final UserModel user;

  const MatchDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.username)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Profil (besar)
            if (user.profileImageUrl != null &&
                user.profileImageUrl!.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      user.profileImageUrl!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person_outline,
                        size: 150,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.person_outline,
                    size: 150,
                    color: Colors.grey,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user.bio != null && user.bio!.isNotEmpty)
                    Text(
                      user.bio!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Informasi Lokasi
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.blueAccent,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user.location != null
                            ? 'Location: Lat ${user.location!.latitude.toStringAsFixed(4)}, Lng ${user.location!.longitude.toStringAsFixed(4)}'
                            : 'Location unknown',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Contoh: Jarak dari pengguna saat ini (memerlukan lokasi pengguna saat ini)
                  // Jika Anda punya lokasi pengguna saat ini (misal dari AuthProvider atau dari MapService)
                  // final currentLatLng = LatLng(currentLatitude, currentLongitude);
                  // final matchLatLng = LatLng(user.location!.latitude, user.location!.longitude);
                  // final distance = MapService().calculateDistance(
                  //   GeoPoint(currentLatLng.latitude, currentLatLng.longitude),
                  //   GeoPoint(matchLatLng.latitude, matchLatLng.longitude),
                  // );
                  // Text('Approx. ${distance.round() / 1000} km away', style: TextStyle(fontSize: 16, color: Colors.grey)),

                  // Informasi Kontak (jika relevan, atau cara lain untuk berinteraksi)
                  const SizedBox(height: 16),
                  const Text(
                    'Contact & Interests',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Email: ${user.email}'),

                  // Tambahkan minat, hobi, dll.
                  // Misalnya:
                  // Wrap(
                  //   spacing: 8.0,
                  //   children: user.interests.map((interest) => Chip(label: Text(interest))).toList(),
                  // ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Implementasi chat atau interaksi lain
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Start Chatting feature coming soon!',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.message, color: Colors.white),
                      label: const Text('Send Message'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
