import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/button_widget.dart';
import 'package:fypmerchant/Components/textTitle_widget.dart';
import 'package:fypmerchant/Firebase/update_data.dart';
import 'package:fypmerchant/Firebase/view_order.dart';
import '../../../Components/spinner_widget.dart';
import '../../../Firebase/retrieve_data.dart';

class PreparingOrderTablet extends StatefulWidget {
  final Function(String) onSelectOrder;
  const PreparingOrderTablet({Key? key, required this.onSelectOrder}) : super(key: key);

  @override
  State<PreparingOrderTablet> createState() => _PreparingOrderTabletState();
}

class _PreparingOrderTabletState extends State<PreparingOrderTablet> {
  Stream<QuerySnapshot> stream = const Stream.empty();

  String? selectedOrderId;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    setState(() {
      stream = FirebaseFirestore.instance.collection('Orders').where("order_Status", isEqualTo: "Preparing").snapshots();
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

class PreparingOrderDetails extends StatefulWidget {
  final String orderId;
  final VoidCallback onClearSelectedOrder;

  const PreparingOrderDetails({
    Key? key,
    required this.orderId,
    required this.onClearSelectedOrder,
  }) : super(key: key);

  @override
  State<PreparingOrderDetails> createState() => _PreparingOrderDetailsState();
}

class _PreparingOrderDetailsState extends State<PreparingOrderDetails> {
  Stream<QuerySnapshot> stream = const Stream.empty();
  double grandTotal = 0.0;
  String payment_method = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    RetrieveData().fetchPaidAmount(widget.orderId, (double paidAmount, String paymentMethod) {
      setState(() {
        grandTotal = paidAmount;
        payment_method = paymentMethod;
      });
    });
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    setState(() {
      stream = FirebaseFirestore.instance.collection('Orders').doc(widget.orderId).collection('items').snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Spinner.loadingSpinner();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error : ${snapshot.error}'),
                    );
                  } else {
                    final List<Widget> orderList = [];
                    final docs = snapshot.data?.docs ?? [];
                    for (var doc in docs) {
                      var itemPicture = doc['item_picture'];
                      var itemName = doc['item_name'];
                      var itemPrice = doc['price'];
                      var quantity = doc['quantity'];

                      orderList.add(
                        OrderItemList(
                          itemPicture: itemPicture,
                          itemName: itemName,
                          itemPrice: itemPrice,
                          itemQuantity: quantity,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      child: Column(
                        children: orderList,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrandTitle.totalTitle(
                        'Payment : $payment_method',
                        18,
                        FontWeight.w600,
                      ),
                      GrandTitle.totalTitle(
                        'Grand total : RM ${grandTotal.toStringAsFixed(2)}',
                        18,
                        FontWeight.w600,
                      ),
                    ],
                  ),
                  ///THIS MANAGE ORDER NEED TO REPLACE YAAA
                  ButtonWidget.buttonWidget(
                    "Ready for pickup",
                        () {
                      ManageOrder().readyForPickup(context, widget.orderId);
                      widget.onClearSelectedOrder();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}