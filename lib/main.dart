import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // REMOVED Firebase import
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import all necessary local components
import 'package:dating/auth/screens/login_screen.dart';
import 'package:dating/bottom_nav/screens/main_app_screen.dart';
import 'package:dating/core/providers/auth_provider.dart'; // YOUR AUTH PROVIDER
import 'package:dating/config/theme.dart';
import 'package:dating/data/local_storage/session_manager.dart';
import 'package:dating/routes/app_router.dart';

// Your LOCAL versions of Repositories and Services
import 'package:dating/api/services/auth_service.dart'; // Local AuthService
import 'package:dating/api/services/user_service.dart'; // Local UserService
import 'package:dating/api/services/currency_service.dart'; // Assuming this is also local or mockable

import 'package:dating/data/repositories/user_repository.dart'; // This will depend on local UserService
import 'package:dating/data/repositories/match_repository.dart'; // This will be your local MatchRepository
import 'package:dating/data/repositories/currency_repository.dart'; // This will depend on local CurrencyService

// Your Providers and ViewModels
import 'package:dating/core/providers/user_provider.dart';
import 'package:dating/features/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:dating/features/profile/viewmodels/profile_viewmodel.dart';
import 'package:dating/features/currency_converter/viewmodels/currency_converter_viewmodel.dart';
import 'package:dating/features/search_filter/viewmodels/search_filter_viewmodel.dart';
import 'package:dating/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:dating/data/local_storage/settings_manager.dart'; // Assuming this is purely local

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        // Local Services (sebagai dependensi dasar yang tidak berstate)
        // AuthService tetap disediakan jika ada kelas lain yang mungkin membutuhkannya
        // meskipun AuthProvider tidak lagi menggunakannya melalui injeksi konstruktor.
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<UserService>(create: (_) => UserService()),
        Provider<CurrencyService>(create: (_) => CurrencyService()),

        // Auth Provider (mengelola status autentikasi global)
        ChangeNotifierProvider<AuthProvider>(
          // CUKUP BUAT INSTANCE AUTHPROVIDER TANPA ARGUMEN
          create: (context) => AuthProvider(),
        ),

        // Repositories (Menggunakan Services sebagai dependensi)
        Provider<UserRepository>(
          create: (context) => UserRepository(
            userService: Provider.of<UserService>(context, listen: false),
          ),
        ),
        Provider<MatchRepository>(
          create: (_) =>
              MatchRepository(), // MatchRepository tidak punya dependency service langsung
        ),
        Provider<CurrencyRepository>(
          create: (context) => CurrencyRepository(
            currencyService: Provider.of<CurrencyService>(
              context,
              listen: false,
            ),
          ),
        ),

        // Core Providers (Global state yang tergantung pada Repositories/Auth)
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(
            Provider.of<UserRepository>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false),
          ),
          lazy: false,
        ),

        // Feature-specific ViewModels (Menggunakan Repositories/Providers lain sebagai dependensi)
        ChangeNotifierProvider<DashboardViewModel>(
          create: (context) => DashboardViewModel(
            Provider.of<UserRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (context) => ProfileViewModel(
            // ProfileViewModel now directly uses UserService
            Provider.of<UserService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<CurrencyConverterViewModel>(
          create: (context) => CurrencyConverterViewModel(
            Provider.of<CurrencyService>(context, listen: false),
            Provider.of<UserRepository>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false),
            userProvider: Provider.of<UserProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<SearchFilterViewModel>(
          create: (context) => SearchFilterViewModel(
            Provider.of<UserRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<SettingsViewModel>(
          create: (_) => SettingsViewModel(),
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
