import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../Color/color.dart';
import '../../../Components/spinner_widget.dart';
import 'mainArea_Order.dart';

class ReceiveOrderTablet extends StatefulWidget {
  final Function(String?) onCardTap;
  const ReceiveOrderTablet({Key? key, required this.onCardTap}) : super(key: key);

  @override
  State<ReceiveOrderTablet> createState() => _ReceiveOrderTabletState();
}

class _ReceiveOrderTabletState extends State<ReceiveOrderTablet> {
  Stream<QuerySnapshot> stream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    setState(() {
      stream = FirebaseFirestore.instance.collection('Orders').snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ViewOrderTablet(onCardTap: widget.onCardTap),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Spinner.loadingSpinner();
              }else if(snapshot.hasError){
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              }else{
                final List<Widget> orderList = [];
                final docs = snapshot.data?.docs ?? [];
                for(var doc in docs){
                  var orderId = doc['order_id'];
                  orderList.add(
                      ItemCard(
                        order_Id: orderId,
                        onTap: widget.onCardTap, // Pass onTap method from parent widget
                      )
                  );

                }
                return SingleChildScrollView(
                  child: Column(
                      children: orderList
                  ),
                );
              }
            }
        ),
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final order_Id;
  final Function(String?) onTap;
  const ItemCard({Key? key, required this.order_Id, required this.onTap}) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: () {
          widget.onTap(widget.order_Id); // Call onTap method and pass order_id
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  width: constraints.maxWidth,
                  margin: const EdgeInsets.only(left: 20),
                  height: 80, // Fixed height
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.order_Id, // Display the actual order ID
                      style: const TextStyle(
                        color: CustomColors.lightGreen,
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
    );
  }
}


