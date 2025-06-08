import 'package:dating/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating/features/profile/viewmodels/profile_viewmodel.dart';
import 'package:dating/core/providers/auth_provider.dart';
import 'package:dating/features/profile/widgets/profile_header.dart'; // Akan dibuat
import 'package:dating/features/profile/widgets/edit_profile_dialog.dart'; // Akan dibuat

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUserId != null) {
        Provider.of<ProfileViewModel>(context, listen: false)
            .fetchCurrentUser(authProvider.currentUserId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Tampilkan dialog edit profil
              showDialog(
                context: context,
                builder: (context) => EditProfileDialog(
                  currentUser: Provider.of<ProfileViewModel>(context, listen: false).currentUser,
                  onSave: (username, bio) {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    if (authProvider.currentUserId != null) {
                      Provider.of<ProfileViewModel>(context, listen: false)
                          .updateProfile(authProvider.currentUserId!, username: username, bio: bio);
                    }
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()), // Kembali ke login
              );
            },
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }
          if (viewModel.currentUser == null) {
            return const Center(child: Text('Profile not found.'));
          }

          final user = viewModel.currentUser!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(
                  user: user,
                  onImageTap: () async {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    if (authProvider.currentUserId != null) {
                      await viewModel.uploadProfileImage(authProvider.currentUserId!);
                    }
                  },
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('About Me', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(user.bio != null && user.bio!.isNotEmpty ? user.bio! : 'No bio yet.'),
                        const SizedBox(height: 16),
                        const Text('Contact Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Email: ${user.email}'),
                        // Tambahkan informasi lain
                        const SizedBox(height: 16),
                        const Text('Current Balance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Rp ${user.balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Colors.green)),
                        Text('Joined: ${user.createdAt.toLocal().toString().split(' ')[0]}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}