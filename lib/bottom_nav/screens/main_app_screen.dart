import 'package:flutter/material.dart';
import 'package:dating/features/dashboard/screens/dashboard_screen.dart';
import 'package:dating/features/profile/screens/profile_screen.dart';
import 'package:dating/features/currency_converter/screens/currency_converter_screen.dart';
import 'package:dating/features/search_filter/screens/search_filter_screen.dart';
import 'package:dating/features/settings/screens/settings_screen.dart';
import 'package:provider/provider.dart';
// ViewModels sudah disediakan via MultiProvider di main.dart, jadi tidak perlu di sini

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    SearchFilterScreen(),
    CurrencyConverterScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        onTap: _onItemTapped,
        type: Theme.of(context).bottomNavigationBarTheme.type,
        selectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
      ),
    );
  }
}