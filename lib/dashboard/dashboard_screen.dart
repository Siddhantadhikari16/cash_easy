import 'package:cash_easy/dashboard/notification_screen.dart';
import 'package:flutter/material.dart';

import '../appbar/custom_appbar.dart';
import 'calculator_screen/calculator_screen.dart';
import 'history_screen/history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CalculatorScreen(),
    HistoryScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(
            child: Text(
          "Cash Easy",
          style: TextStyle(fontSize: 30),
        )),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()));
            },
            icon: Icon(Icons.notifications)),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.teal,
        elevation: 1,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calculate,
                color: Colors.teal,
              ),
              label: "Calculate"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                color: Colors.teal,
              ),
              label: "History"),
        ],
      ),
    );
  }
}
