import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating/core/providers/auth_provider.dart';
import 'package:dating/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:dating/routes/app_router.dart'; // Untuk navigasi setelah logout

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<SettingsViewModel>(
        builder: (context, viewModel, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Dark Mode'),
                        trailing: Switch(
                          value: viewModel.darkModeEnabled,
                          onChanged: (value) {
                            viewModel.toggleDarkMode(value);
                            // Anda mungkin ingin memperbarui tema aplikasi secara global di sini
                            // Tergantung pada bagaimana Anda mengelola tema
                          },
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Notifications'),
                        trailing: Switch(
                          value: viewModel.notificationsEnabled,
                          onChanged: (value) {
                            viewModel.toggleNotifications(value);
                            // Logika untuk mengaktifkan/menonaktifkan notifikasi push
                          },
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Language'),
                        trailing: DropdownButton<String>(
                          value: viewModel.selectedLanguage,
                          onChanged: (String? newValue) {
                            viewModel.changeLanguage(newValue);
                          },
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(
                              value: 'en',
                              child: Text('English'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'id',
                              child: Text('Bahasa Indonesia'),
                            ),
                            // Tambahkan bahasa lain
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      // Panggil metode logout dari AuthProvider
                      await Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).logout();
                      // Navigasi kembali ke halaman login
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRouter.loginRoute,
                        (Route<dynamic> route) =>
                            false, // Hapus semua rute sebelumnya
                      );
                    },
                  ),
                ),
              ),
              // Anda bisa menambahkan opsi lain di sini:
              // - Privacy Policy
              // - Terms of Service
              // - About App
              // - Delete Account (dengan konfirmasi)
            ],
          );
        },
      ),
    );
  }
}
