import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/button_widget.dart';
import 'package:fypmerchant/Components/textTitle_widget.dart';
import 'package:fypmerchant/Firebase/retrieve_data.dart';
import 'package:fypmerchant/Firebase/update_data.dart';
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
                  return IncomingOrderCard(orderId: orderId);
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

class IncomingOrderCard extends StatefulWidget {
  final String orderId;
  const IncomingOrderCard({Key? key,required this.orderId});

  @override
  State<IncomingOrderCard> createState() => _IncomingOrderCardState();
}

class _IncomingOrderCardState extends State<IncomingOrderCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShowOrderPageMobile(orderId: widget.orderId,)));
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
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 80,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.orderId,
                      style: const TextStyle(
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

class ShowOrderPageMobile extends StatefulWidget {
  final String orderId;

  const ShowOrderPageMobile({
    super.key,
    required this.orderId,
  });

  @override
  State<ShowOrderPageMobile> createState() => _ShowOrderPageMobileState();
}

class _ShowOrderPageMobileState extends State<ShowOrderPageMobile> {
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
      appBar: AppBar(
        backgroundColor: CustomColors.defaultWhite,
        title: AppBarWidget.bartext(widget.orderId),
        elevation: 0,
      ),
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
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GrandTitle.totalTitle(
                        'Payment : $payment_method',
                        15,
                        FontWeight.w600,
                      ),
                      GrandTitle.totalTitle(
                        'Grand total : RM ${grandTotal.toStringAsFixed(2)}',
                        15,
                        FontWeight.w600,
                      ),

                      SizedBox(
                        width: 390,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ButtonWidget.buttonWidget(
                              "Accept",
                                  () {
                                ManageOrder().acceptOrder(context, widget.orderId, grandTotal);
                                Navigator.pop(context);
                              },
                            ),
                            ButtonWidget.buttonWidget(
                              "Reject",
                                  () {
                                ManageOrder().rejectOrder(context, widget.orderId);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}