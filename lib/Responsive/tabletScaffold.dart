import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Tablet/DashboardTablet.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTablet.dart';

//temp import
import '../Color/color.dart';
import '../Components/barTitle_widget.dart';
import '../Responsive/Mobile/OrderTabsMobile/PendingOrderMobile.dart';
import '../Responsive/Mobile/OrderTabsMobile/ReceiveOrderMobile.dart';
import '../Responsive/Mobile/profile.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({super.key});

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const OrderTablet(),
    const DashboardTablet(),
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
