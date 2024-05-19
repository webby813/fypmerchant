import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/button_widget.dart';
import 'package:fypmerchant/Firebase/retrieve_data.dart';
import 'package:fypmerchant/Firebase/update_data.dart';
import '../Components/spinner_widget.dart';
import '../Components/textTitle_widget.dart';

class ShowOrderPageTablet extends StatefulWidget {
  final String orderId;
  final VoidCallback onClearSelectedOrder;

  const ShowOrderPageTablet({
    Key? key,
    required this.orderId,
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

          ///This overflow on right at mobile interface
          Expanded(
            flex: 2,
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
                    ManageOrder().acceptOrder(context, widget.orderId, grandTotal);
                    widget.onClearSelectedOrder(); // Clear selected order
                  },
                ),
                ButtonWidget.buttonWidget(
                  "Reject",
                      () {
                    ManageOrder().rejectOrder(context, widget.orderId);
                    widget.onClearSelectedOrder(); // Clear selected order
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final String orderId;
  final bool isSelected;
  final Function(String) selectOrder;

  const ItemCard({
    Key? key,
    required this.orderId,
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
          widget.selectOrder(widget.orderId);
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
                        widget.orderId, // Display the actual order ID
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


class OrderItemList extends StatefulWidget {
  final itemPicture;
  final itemName;
  final itemPrice;
  final itemQuantity;

  const OrderItemList({
    Key? key,
    required this.itemPicture,
    required this.itemName,
    required this.itemPrice,
    required this.itemQuantity,
  });

  @override
  State<OrderItemList> createState() => _OrderItemListState();
}

class _OrderItemListState extends State<OrderItemList> {
  late Future<String?> _pictureUrlFuture;

  @override
  void initState() {
    super.initState();
    _pictureUrlFuture = RetrievePicture().loadItemPicture(widget.itemPicture);
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
                    OrderTitle.orderTitle('Product name : ${widget.itemName}' ?? '', 18, FontWeight.w600),
                    OrderTitle.orderTitle('RM ${widget.itemPrice}' ?? '', 16, FontWeight.w600),
                    OrderTitle.orderTitle('Quantity : ${widget.itemQuantity.toString()} ' ?? '', 16, FontWeight.w600),
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