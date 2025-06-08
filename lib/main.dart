import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:dating/auth/screens/login_screen.dart'; // Tidak lagi langsung di `home`
import 'package:dating/bottom_nav/screens/main_app_screen.dart'; // Halaman utama
import 'package:dating/core/providers/auth_provider.dart';
import 'package:dating/config/theme.dart';
import 'package:dating/data/local_storage/session_manager.dart';
import 'package:dating/routes/app_router.dart'; // Import AppRouter

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inisialisasi Firebase
  await Hive.initFlutter(); // Inisialisasi Hive
  await SessionManager.init(); // Inisialisasi SessionManager

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Tambahkan provider lain di sini jika diperlukan secara global
      ],
      child: MaterialApp(
        title: 'Dating App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute:
            AppRouter.generateRoute, // Gunakan AppRouter untuk mengelola rute
        initialRoute: AppRouter.loginRoute, // Atur rute awal ke login
        // Logika untuk navigasi awal berdasarkan AuthProvider bisa ditempatkan di SplashScreen atau di AuthProvider sendiri
        builder: (context, child) {
          // Logika untuk mengarahkan pengguna setelah splash screen atau startup
          return Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isAuthenticated) {
                // Jika sudah login, langsung ke halaman utama
                return const MainAppScreen();
              } else {
                // Jika belum login, ke halaman login
                return const LoginScreen();
              }
            },
          );
        },
      ),
    );
  }
}
