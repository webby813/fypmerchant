import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Mobile/DashboardMobile.dart';
import 'package:fypmerchant/Responsive/Mobile/OrderMobile.dart';
import 'Mobile/profile.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({super.key});

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const OrderMobile(),
    const DashboardMobile(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Order',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Dashboard',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Manage',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
