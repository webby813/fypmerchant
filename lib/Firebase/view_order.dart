import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/button_widget.dart';
import 'package:fypmerchant/Firebase/retrieve_data.dart';
import 'package:fypmerchant/Firebase/update_data.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Components/spinner_widget.dart';
import '../Components/textTitle_widget.dart';

class ShowOrderPageTablet extends StatefulWidget {
  final String order_id;
  final VoidCallback onClearSelectedOrder; // Add this callback

  const ShowOrderPageTablet({
    Key? key,
    required this.order_id,
    required this.onClearSelectedOrder,
  }) : super(key: key);

  @override
  State<ShowOrderPageTablet> createState() => _ShowOrderPageTabletState();
}

class _ShowOrderPageTabletState extends State<ShowOrderPageTablet> {
  Stream<QuerySnapshot> stream = const Stream.empty();
  double grandTotal = 0.0;
  String payment_method = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    RetrieveData().fetchPaidAmount(widget.order_id, (double paidAmount, String paymentMethod) {
      setState(() {
        grandTotal = paidAmount;
        payment_method = paymentMethod;
      });
    });
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    setState(() {
      stream = FirebaseFirestore.instance.collection('Orders').doc(widget.order_id).collection('items').snapshots();
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
                          item_picture: itemPicture,
                          item_name: itemName,
                          item_price: itemPrice,
                          item_quantity: quantity,
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

          ///This overflow on right at mobile interface
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
                  ButtonWidget.buttonWidget(
                    "Accept",
                        () {
                      ManageOrder().acceptOrder(context, widget.order_id, grandTotal);
                      widget.onClearSelectedOrder(); // Clear selected order
                    },
                  ),
                  ButtonWidget.buttonWidget(
                    "Reject",
                        () {
                      ManageOrder().rejectOrder(context, widget.order_id);
                      widget.onClearSelectedOrder(); // Clear selected order
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


class OrderItemList extends StatefulWidget {
  final item_picture;
  final item_name;
  final item_price;
  final item_quantity;

  const OrderItemList({
    Key? key,
    required this.item_picture,
    required this.item_name,
    required this.item_price,
    required this.item_quantity,
  });

  @override
  State<OrderItemList> createState() => _OrderItemListState();
}

class _OrderItemListState extends State<OrderItemList> {
  late Future<String?> _pictureUrlFuture;

  @override
  void initState() {
    super.initState();
    _pictureUrlFuture = RetrievePicture().loadItemPicture(widget.item_picture);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Card(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: SizedBox(
                width: screenSize.width * 0.2, // Adjust this value as needed
                height: screenSize.width * 0.2, // Adjust this value as needed
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FutureBuilder<String?>(
                    future: _pictureUrlFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Spinner.loadingSpinner();
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error);
                      } else if (snapshot.hasData) {
                        return Image.network(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const Icon(Icons.error);
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderTitle.orderTitle('Product name : ${widget.item_name}' ?? '', 18, FontWeight.w600),
                    OrderTitle.orderTitle('RM ${widget.item_price}' ?? '', 16, FontWeight.w600),
                    OrderTitle.orderTitle('Quantity : ${widget.item_quantity.toString()} ' ?? '', 16, FontWeight.w600),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class ShowOrderPageMobile extends StatefulWidget {
  final String order_id;

  const ShowOrderPageMobile({
    super.key,
    required this.order_id,

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
    RetrieveData().fetchPaidAmount(widget.order_id, (double paidAmount, String paymentMethod) {
      setState(() {
        grandTotal = paidAmount;
        payment_method = paymentMethod;
      });
    });
    _initializeStream();
  }

  Future<void> _initializeStream() async {
    setState(() {
      stream = FirebaseFirestore.instance.collection('Orders').doc(widget.order_id).collection('items').snapshots();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.defaultWhite,
        title: AppBarWidget.bartext(widget.order_id),
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
                          item_picture: itemPicture,
                          item_name: itemName,
                          item_price: itemPrice,
                          item_quantity: quantity,
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
                                ManageOrder().acceptOrder(context, widget.order_id, grandTotal);
                                Navigator.pop(context);
                                },
                            ),
                            ButtonWidget.buttonWidget(
                              "Reject",
                                  () {
                                ManageOrder().rejectOrder(context, widget.order_id);
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
