import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Color/color.dart';
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
                    order_Id: orderId,
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

class ItemCard extends StatefulWidget {
  final String order_Id;
  final bool isSelected;
  final Function(String) selectOrder;

  const ItemCard({
    Key? key,
    required this.order_Id,
    required this.isSelected,
    required this.selectOrder,
  }) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: GestureDetector(
        onTap: () {
          widget.selectOrder(widget.order_Id);
        },
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: widget.isSelected ? CustomColors.lightGreen : CustomColors.defaultWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 80, // Fixed height
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.order_Id, // Display the actual order ID
                        style: TextStyle(
                          color: widget.isSelected ? CustomColors.defaultWhite : CustomColors.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
