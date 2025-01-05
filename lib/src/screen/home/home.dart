import 'package:flutter/material.dart';
import 'package:muday/src/app.dart';
import 'package:muday/src/screen/home/main_screen.dart';
import 'package:muday/src/settings/settings_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    print('Selected Index: $index');
    // Adjust index for FAB
    // if (index >= 2) {
    //   index += 1; // Skip the FAB index
    // }

    if (index == 1) {
      Navigator.restorablePushNamed(context, Routes.transactionList);
    } else if (index == 3) {
      Navigator.restorablePushNamed(context, SettingsView.routeName);
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainScreen(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Handle add button press
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Add Button Pressed')),
            // );
          },
          shape: const CircleBorder(),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Color(0xFF29756F),
            ),
            child: const Icon(Icons.add, size: 40),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.grey.shade300,
        selectedItemColor: Theme.of(context).colorScheme.tertiary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              // depending on the selected index change the color
              // color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Transaction',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Budget',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
