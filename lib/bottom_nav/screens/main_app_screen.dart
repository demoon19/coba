import 'package:flutter/material.dart';
import 'package:dating/features/dashboard/screens/dashboard_screen.dart';
import 'package:dating/features/profile/screens/profile_screen.dart';
import 'package:dating/features/currency_converter/screens/currency_converter_screen.dart';
import 'package:dating/features/notifications/screens/notification_screen.dart';
import 'package:dating/features/search_filter/screens/search_filter_screen.dart';
import 'package:provider/provider.dart';
import 'package:dating/features/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'package:dating/features/profile/viewmodels/profile_viewmodel.dart';
import 'package:dating/features/currency_converter/viewmodels/currency_converter_viewmodel.dart';
import 'package:dating/features/search_filter/viewmodels/search_filter_viewmodel.dart';
// Untuk mendapatkan saldo pengguna

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    SearchFilterScreen(), // Fasilitas pencarian dan pemilihan
    CurrencyConverterScreen(), // Konversi mata uang
    NotificationScreen(), // Notifikasi
    ProfileScreen(), // Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => CurrencyConverterViewModel()),
        ChangeNotifierProvider(create: (_) => SearchFilterViewModel()),
        // Jika ada viewmodel lain yang diperlukan di level ini
      ],
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange),
              label: 'Currency',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed, // Penting untuk lebih dari 3 item
        ),
      ),
    );
  }
}