import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTabsTablet/incoming_order_tablet.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTabsTablet/preparing_order_tablet.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTabsTablet/finished_order_tablet.dart';
import '../../../Color/color.dart';
import '../../Components/container_widget.dart';
import '../../Components/textTitle_widget.dart';
import '../../Firebase/view_order.dart';

class OrderTablet extends StatefulWidget {
  const OrderTablet({Key? key}) : super(key: key);

  @override
  State<OrderTablet> createState() => _OrderTabletState();
}

class _OrderTabletState extends State<OrderTablet> {
  String selectedAction = "Incoming";
  String? selectedOrderId;

  void _selectOrder(String orderId) {
    setState(() {
      selectedOrderId = orderId;
    });
  }

  void _clearSelectedOrder() {
    setState(() {
      selectedOrderId = null;
    });
  }

  Widget _buildActionContent() {
    switch (selectedAction) {
      case "Incoming":
        return IncomingOrderTablet(onSelectOrder: _selectOrder);
      case "Preparing":
        return PreparingOrderTablet(onSelectOrder: _selectOrder);
      case "Finished":
        return FinishedOrderTablet(onSelectOrder: _selectOrder);
      default:
        return const Scaffold();
    }
  }

  Widget _buildMainContent() {
    if (selectedOrderId != null) {
      switch (selectedAction) {
        case "Incoming":
          return ShowOrderPageTablet(
            key: ValueKey(selectedOrderId),
            orderId: selectedOrderId!,
            onClearSelectedOrder: _clearSelectedOrder,
          );
        case "Preparing":
          return PreparingOrderDetails(
            key: ValueKey(selectedOrderId),
            orderId: selectedOrderId!,
            onClearSelectedOrder: _clearSelectedOrder,
          );
        case "Finished":
          return FinishedOrderDetails(
            key: ValueKey(selectedOrderId),
            orderId: selectedOrderId!,
            onClearSelectedOrder: _clearSelectedOrder,
          );
        default:
          return const Scaffold();
      }
    } else {
      return const Scaffold();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.defaultWhite,
        title: AppBarWidget.bartext('Orders'),
        elevation: 0,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SelectableAction(
                  label: "Incoming Order",
                  isSelected: selectedAction == "Incoming",
                  onTap: () {
                    setState(() {
                      selectedAction = "Incoming";
                      selectedOrderId = null; // Reset selected order
                    });
                  },
                ),
                SelectableAction(
                  label: "Preparing Order",
                  isSelected: selectedAction == "Preparing",
                  onTap: () {
                    setState(() {
                      selectedAction = "Preparing";
                      selectedOrderId = null; // Reset selected order
                    });
                  },
                ),
                SelectableAction(
                  label: "Finished Orders",
                  isSelected: selectedAction == "Finished",
                  onTap: () {
                    setState(() {
                      selectedAction = "Finished";
                      selectedOrderId = null; // Reset selected order
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: CustomColors.secondaryWhite,
              child: _buildActionContent(),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.grey,
              child: _buildMainContent(),
            ),
          ),
        ],
      ),
    );
  }
}