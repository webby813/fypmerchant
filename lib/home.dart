import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/mobileScaffold.dart';
import 'package:fypmerchant/Responsive/tabletScaffold.dart';

import 'Responsive/responsive_layout.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ResponsiveLayout(
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold()
      ),
    );
  }
}
