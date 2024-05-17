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

class ViewOrder extends StatefulWidget {
  final double? maxWidth;

  const ViewOrder({Key? key, this.maxWidth}) : super(key: key);

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}
class _ViewOrderState extends State<ViewOrder> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('Order');

  String? username;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        FirebaseAnimatedList(
          shrinkWrap: true,
          query: query,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
            Map data = snapshot.value as Map;
            data['key'] = snapshot.key;
            username = data['key'].toString();

            return FutureBuilder<String?>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return Padding(
                  padding: const EdgeInsets.all(6),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowOrderPage(username: username.toString()),
                        ),
                      );
                    },

                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          SizedBox(
                            width: 130,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    username.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 55,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, future: null,
            );
          },
        )
      ],
    );
  }
}

class ShowOrderPage extends StatefulWidget {
  final String username;
  const ShowOrderPage({Key? key, required this.username}) : super(key: key);

  @override
  State<ShowOrderPage> createState() => _ShowOrderPageState();
}
class _ShowOrderPageState extends State<ShowOrderPage> {
  late DatabaseReference query;
  String? username;

  String? imageUrl;
  String? userShared;


  List<Map<dynamic, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    String username = widget.username;
    query = FirebaseDatabase.instance.ref().child('Order/${widget.username}');
  }

  Future<String?> getImageUrl(String imageName) async {
    try {
      Reference imageRef = FirebaseStorage.instance.ref().child('Item/$imageName');
      String imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  void acceptAllOrders() {
    for(final order in orders){
      AcceptOrder().readCartData(widget.username);
    }
  }

  void rejectAllOrders() {
    for (final order in orders) {
      RejectOrder().rejectUserOrder(widget.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        actions: [
          TextButton(
            onPressed: (){
              AcceptOrder().readCartData(widget.username);
            },
            child: const Text(
              'Accept All',
              style: TextStyle(color: CustomColors.lightGreen),
            ),
          ),
          TextButton(
            onPressed: rejectAllOrders,
            child: const Text(
              'Reject All',
              style: TextStyle(color: CustomColors.warningRed),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: <Widget>[
              FirebaseAnimatedList(
                shrinkWrap: true,
                query: query,
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  dynamic data = snapshot.value;

                  if (data is Map) {

                    data['key'] = snapshot.key;
                    orders.add(data);
                    return FutureBuilder<String?>(
                      future: getImageUrl(data['itemImage']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        imageUrl = snapshot.data ?? 'https://fastly.picsum.photos/id/237/536/354.jpg?hmac=i0yVXW1ORpyCZpQ-CknuyV-jbtU7_x9EBQVhvT5aRr0';
                        String itemName = data['itemName']?.toString() ?? '';
                        double price = data['price']?.toDouble() ?? 0.0;
                        int qty = data['qty'] as int? ?? 0;

                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      imageUrl!,
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.only(left: 10)),
                                SizedBox(
                                  width: 130,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 0, 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          itemName,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          price.toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: CustomColors.primaryColor,
                                          ),
                                        ),
                                        const Padding(padding: EdgeInsets.all(10)),
                                        Text(
                                          qty.toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            color: CustomColors.lightGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowOrderPageTablet extends StatefulWidget {
  final order_id;
  const ShowOrderPageTablet({Key? key, required this.order_id}) : super(key: key);

  @override
  State<ShowOrderPageTablet> createState() => _ShowOrderPageTabletState();
}

class _ShowOrderPageTabletState extends State<ShowOrderPageTablet> {
  Stream<QuerySnapshot> stream = const Stream.empty();

  void initState() {
    super.initState();
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
                  var item_picture = doc['item_picture'];
                  var item_name = doc['item_name'];
                  var item_price = doc['price'];
                  var quantity = doc['quantity'];

                  orderList.add(
                      OrderItemList(
                          item_picture: item_picture,
                          item_name: item_name,
                          item_price: item_price,
                          item_quantity: quantity
                      )
                  );

                }
                return SingleChildScrollView(
                  child: Column(
                      children: orderList
                  ),
                );
              }
            },
          ),
        )
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

  void initState(){
    super.initState();
    _pictureUrlFuture = RetrievePicture().loadItemPicture(widget.item_picture);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Card(
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                child: SizedBox(
                  width: 180,
                  height: 170,
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
                )
            ),

            Container(
              margin: const EdgeInsets.only(left: 10),
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 400,
                    child: OrderTitle.orderTitle('Product name : ${widget.item_name}' ?? '', 18, FontWeight.w600),
                  ),
                  SizedBox(
                    width: 400,
                    child: OrderTitle.orderTitle('RM ${widget.item_price}' ?? '', 16, FontWeight.w600),
                  ),
                  SizedBox(
                    width: 400,
                    child: OrderTitle.orderTitle('Quantity : ${widget.item_quantity.toString()} ' ?? '', 16, FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}