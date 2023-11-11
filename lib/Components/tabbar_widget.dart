import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  final List<Tab> tabs;
  final List<Widget> tabViews;

  TabBarWidget({required this.tabs, required this.tabViews});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
    );
  }

  TabBarView buildTabBarView() {
    return TabBarView(
      children: tabViews,
    );
  }
}
