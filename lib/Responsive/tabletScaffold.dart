import 'package:flutter/material.dart';

//temp import
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
    const ReceiveOrderMobile(),
    const PendingOrderMobile(),
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
            icon: Icon(Icons.play_circle_filled),
            label: 'Pending',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
