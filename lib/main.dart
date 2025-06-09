import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import semua yang dibutuhkan
import 'package:dating/auth/screens/login_screen.dart';
import 'package:dating/bottom_nav/screens/main_app_screen.dart';
import 'package:dating/core/providers/auth_provider.dart';
import 'package:dating/config/theme.dart';
import 'package:dating/data/local_storage/session_manager.dart';
import 'package:dating/routes/app_router.dart';
import 'package:dating/data/repositories/user_repository.dart';
import 'package:dating/core/providers/user_provider.dart';
import 'package:dating/features/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:dating/features/profile/viewmodels/profile_viewmodel.dart';
import 'package:dating/features/currency_converter/viewmodels/currency_converter_viewmodel.dart';
import 'package:dating/features/search_filter/viewmodels/search_filter_viewmodel.dart';
import 'package:dating/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:dating/data/repositories/match_repository.dart';
import 'package:dating/data/repositories/currency_repository.dart';
import 'package:dating/data/local_storage/settings_manager.dart';

// Tambahan imports untuk services
import 'package:dating/api/services/auth_service.dart';
import 'package:dating/api/services/user_service.dart';
import 'package:dating/api/services/match_service.dart'; // Jika ada, atau pakai Firestore langsung
import 'package:dating/api/services/currency_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await SessionManager.init();
  await SettingsManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services (sebagai dependensi dasar yang tidak berstate)
        // Dibuat sebagai Provider biasa karena mereka hanya kelas utilitas
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => UserService()),
        // Provider(create: (_) => MatchService()), // Jika Anda membuat MatchService terpisah
        Provider(create: (_) => CurrencyService()),

        // Auth Provider (mengelola status autentikasi global)
        ChangeNotifierProvider(
          create: (context) => AuthProvider(), // AuthService sudah diinisialisasi di dalamnya
        ),

        // Repositories (Menggunakan Services sebagai dependensi)
        Provider(
          create: (context) => UserRepository(
            userService: Provider.of<UserService>(context, listen: false),
          ),
        ),
        Provider(
          create: (context) => MatchRepository(), // MatchRepository tidak punya dependency service langsung
        ),
        Provider(
          create: (context) => CurrencyRepository(
            currencyService: Provider.of<CurrencyService>(context, listen: false),
          ),
        ),

        // Core Providers (Global state yang tergantung pada Repositories/Auth)
        ChangeNotifierProvider(
          create: (context) => UserProvider(
            Provider.of<UserRepository>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false),
          ),
          lazy: false,
        ),

        // Feature-specific ViewModels (Menggunakan Repositories/Providers lain sebagai dependensi)
        ChangeNotifierProvider(
          create: (context) => DashboardViewModel(
            Provider.of<UserRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(
            Provider.of<UserRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CurrencyConverterViewModel(
            Provider.of<CurrencyService>(context, listen: false), // Perhatikan ini bukan repository lagi
            Provider.of<UserRepository>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false),
            userProvider: Provider.of<UserProvider>(context, listen: false), // Optional, untuk update UI saldo
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchFilterViewModel(
            Provider.of<UserRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Dating App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return const MainAppScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}