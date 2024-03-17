import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/button_widget.dart';
import 'package:fypmerchant/Firebase/update_data.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

class ViewOrderTablet extends StatefulWidget {
  final Function(String?) onCardTap;

  const ViewOrderTablet({Key? key,required this.onCardTap}) : super(key: key);

  @override
  State<ViewOrderTablet> createState() => _ViewOrderTabletState();
}

class _ViewOrderTabletState extends State<ViewOrderTablet> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('Order');

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      shrinkWrap: true,
      query: query,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
        Map data = snapshot.value as Map;
        data['key'] = snapshot.key;
        String username = data['key'].toString();

        return FutureBuilder<String?>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            return Padding(
              padding: const EdgeInsets.all(6),
              child: GestureDetector(
                onTap: () {
                  widget.onCardTap(null);
                  widget.onCardTap(username);
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
          },
          future: null,
        );
      },
    );
  }
  @override
  void dispose() {
    widget.onCardTap(null);
    super.dispose();
  }
}


class ShowOrderPageTablet extends StatefulWidget {
  final String username;

  const ShowOrderPageTablet({Key? key, required this.username}) : super(key: key);

  @override
  State<ShowOrderPageTablet> createState() => _ShowOrderPageTabletState();
}
class _ShowOrderPageTabletState extends State<ShowOrderPageTablet> {
  late DatabaseReference query;
  String? username;
  String? imageUrl;
  String? userShared;
  List<Map<dynamic, dynamic>> orders = [];
  bool showOrder = true;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    query = FirebaseDatabase.instance.ref().child('Order/$username');
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
    for (final order in orders) {
      AcceptOrder().readCartData(username!);
    }
    setState(() {
      showOrder = false;
    });
  }

  void rejectAllOrders() {
    for (final order in orders) {
      RejectOrder().rejectUserOrder(username);
    }
    setState(() {
      showOrder = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: showOrder,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: <Widget>[
                      FirebaseAnimatedList(
                        shrinkWrap: true,
                        query: query,
                        itemBuilder: (BuildContext context, DataSnapshot snapshot,
                            Animation<double> animation, int index) {
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
                                imageUrl = snapshot.data ??
                                    'https://fastly.picsum.photos/id/237/536/354.jpg?hmac=i0yVXW1ORpyCZpQ-CknuyV-jbtU7_x9EBQVhvT5aRr0';
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
                                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
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
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ButtonWidget.buttonWidget("Accept", () => acceptAllOrders()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ButtonWidget.buttonWidget("Reject", () => rejectAllOrders()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Visibility(
        visible: !showOrder,
        child: Container(),
      ),
    );
  }
}