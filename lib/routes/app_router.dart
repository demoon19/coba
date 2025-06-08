import 'package:flutter/material.dart';
import 'package:dating/auth/screens/login_screen.dart';
import 'package:dating/auth/screens/register_screen.dart';
import 'package:dating/bottom_nav/screens/main_app_screen.dart';
import 'package:dating/features/matches/screens/match_detail_screen.dart';
import 'package:dating/api/models/user_model.dart'; // Import UserModel

class AppRouter {
  static const String loginRoute = '/';
  static const String registerRoute = '/register';
  static const String mainAppRoute = '/home';
  static const String matchDetailRoute = '/match-detail';
  // Tambahkan rute lain jika diperlukan

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case mainAppRoute:
        return MaterialPageRoute(builder: (_) => const MainAppScreen());
      case matchDetailRoute:
        final args = settings.arguments;
        if (args is UserModel) {
          return MaterialPageRoute(
            builder: (_) => MatchDetailScreen(user: args),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Error: Page not found')),
        );
      },
    );
  }
}
