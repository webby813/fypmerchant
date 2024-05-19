import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Color/color.dart';
import '../../../Components/spinner_widget.dart';
import '../../../Firebase/view_order.dart';

class IncomingOrderMobile extends StatefulWidget {
  const IncomingOrderMobile({Key? key}) : super(key: key);

  @override
  State<IncomingOrderMobile> createState() => _IncomingOrderMobileState();
}

class _IncomingOrderMobileState extends State<IncomingOrderMobile> {
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


  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;

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
                  return OrderCard(order_id: orderId);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final String order_id;
  const OrderCard({Key? key,required this.order_id});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: GestureDetector(
        onTap: (){
          print(widget.order_id);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowOrderPageMobile(order_id: widget.order_id,)));
        },

        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: CustomColors.defaultWhite,
                borderRadius: BorderRadius.circular(10)
            ),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                return Container(
                  width: constraints.maxWidth,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: 80,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.order_id,
                      style: TextStyle(
                        color: CustomColors.primaryColor,
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



