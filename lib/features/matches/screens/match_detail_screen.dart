import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart'; // Ensure this is your local UserModel
import 'dart:io'; // Required for FileImage if using local file paths

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
            // Profile Image (large)
            if (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image( // Use Image widget for more flexibility
                      image: user.profileImageUrl!.startsWith('http') || user.profileImageUrl!.startsWith('https')
                          ? NetworkImage(user.profileImageUrl!) as ImageProvider<Object>
                          : FileImage(File(user.profileImageUrl!)) as ImageProvider<Object>,
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
                  // Location Information
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.blueAccent,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        user.location != null &&
                                user.location!['latitude'] != null &&
                                user.location!['longitude'] != null
                            ? 'Location: Lat ${user.location!['latitude']!.toStringAsFixed(4)}, Lng ${user.location!['longitude']!.toStringAsFixed(4)}'
                            : 'Location unknown',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Example: Distance from current user (requires current user's location)
                  // You would typically get the current user's location from a provider
                  // and then use LocationUtils.calculateDistance.
                  // For example, if you have currentLatitude and currentLongitude:
                  /*
                  // Ensure you import LocationUtils and have current user's location
                  // import 'package:dating/utils/location_utils.dart';
                  // final Map<String, double> currentUserLocation = {'latitude': currentLatitude, 'longitude': currentLongitude};
                  // if (user.location != null && currentUserLocation != null) {
                  //   try {
                  //     final double distanceMeters = LocationUtils.calculateDistance(
                  //       currentUserLocation,
                  //       user.location!,
                  //     );
                  //     Text(
                  //       'Approx. ${LocationUtils.formatDistanceKm(distanceMeters)} away',
                  //       style: const TextStyle(fontSize: 16, color: Colors.grey),
                  //     );
                  //   } catch (e) {
                  //     print('Error calculating distance: $e');
                  //     // Handle error or display a default message
                  //     Text('Distance: N/A', style: const TextStyle(fontSize: 16, color: Colors.grey));
                  //   }
                  // }
                  */

                  // Contact & Interests Information
                  const SizedBox(height: 16),
                  const Text(
                    'Contact & Interests',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Email: ${user.email}'),

                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Implement chat or other interaction
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