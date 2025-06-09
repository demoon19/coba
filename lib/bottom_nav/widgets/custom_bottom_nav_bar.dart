import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<BottomNavigationBarItem> items;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      onTap: onItemTapped,
      type: Theme.of(context).bottomNavigationBarTheme.type,
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedLabelStyle: Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
    );
  }
}