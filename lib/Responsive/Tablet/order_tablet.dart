import 'package:flutter/material.dart';
import 'package:fypmerchant/Responsive/Tablet/OrderTabsTablet/incoming_order_tablet.dart';
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
            child: Container(
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
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: CustomColors.secondaryWhite,
              child: selectedAction == "Incoming"
                  ? IncomingOrderTablet(
                onSelectOrder: _selectOrder,
              )
                  : const Scaffold(),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              color: Colors.grey,
              child: selectedOrderId != null
                  ? ShowOrderPageTablet(
                key: ValueKey(selectedOrderId),
                order_id: selectedOrderId!,
                onClearSelectedOrder: _clearSelectedOrder,
              )
                  : const Scaffold(),
            ),
          ),
        ],
      ),
    );
  }
}
