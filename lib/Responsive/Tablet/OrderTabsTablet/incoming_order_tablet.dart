import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Firebase/view_order.dart';
import '../../../Components/spinner_widget.dart';

class IncomingOrderTablet extends StatefulWidget {
  final Function(String) onSelectOrder;

  const IncomingOrderTablet({Key? key, required this.onSelectOrder}) : super(key: key);

  @override
  State<IncomingOrderTablet> createState() => _IncomingOrderTabletState();
}

class _IncomingOrderTabletState extends State<IncomingOrderTablet> {
  Stream<QuerySnapshot> stream = const Stream.empty();
  String? selectedOrderId;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    setState(() {
      stream = FirebaseFirestore.instance.collection('Orders').where("order_Status", isEqualTo: "Incoming").snapshots();
    });
  }

  void _selectOrder(String orderId) {
    setState(() {
      selectedOrderId = orderId;
    });
    widget.onSelectOrder(orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Spinner.loadingSpinner();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final docs = snapshot.data?.docs ?? [];
            return SingleChildScrollView(
              child: Column(
                children: docs.map((doc) {
                  var orderId = doc['order_id'];
                  return ItemCard(
                    orderId: orderId,
                    isSelected: orderId == selectedOrderId,
                    selectOrder: _selectOrder,
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}