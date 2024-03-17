import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Color/color.dart';

class ViewHistoryOrderTablet extends StatefulWidget {
  final Function(String?) onCardTap;

  const ViewHistoryOrderTablet({Key? key, required this.onCardTap}) : super(key: key);

  @override
  State<ViewHistoryOrderTablet> createState() => _ViewHistoryOrderTabletState();
}

class _ViewHistoryOrderTabletState extends State<ViewHistoryOrderTablet> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('History');
  String? uniqueKey;

  void initState() {
    super.initState();
    uniqueKey = '';
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      shrinkWrap: true,
      query: query,
      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
        Map data = snapshot.value as Map;
        data['key'] = snapshot.key;
        uniqueKey = data['key'].toString();
        return Padding(
          padding: const EdgeInsets.all(6),
          child: GestureDetector(
            onTap: () {
              widget.onCardTap(uniqueKey); // Pass the selected username to the parent widget
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
                            uniqueKey.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          // Padding of 30 seems excessive, you might want to adjust this value.
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 55, // Set a fixed height for the content container
                    // Your content here
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class ShowHistoryPageTablet extends StatefulWidget {
  final String username;

  const ShowHistoryPageTablet({Key? key, required this.username}) : super(key: key);

  @override
  State<ShowHistoryPageTablet> createState() => _ShowHistoryPageTabletState();
}

class _ShowHistoryPageTabletState extends State<ShowHistoryPageTablet> {
  String? username;
  String? imageUrl;
  String? userShared;
  String? uniqueKey;
  late DatabaseReference query = FirebaseDatabase.instance.ref().child('History');
  List<Map<dynamic, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    uniqueKey = widget.username;
    query = FirebaseDatabase.instance.ref().child('History/$uniqueKey');
  }

  Future<String?> getImageUrl(String imageName) async {
    try {
      Reference imageRef = FirebaseStorage.instance.ref().child('Item/$imageName');
      String imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      // print("Error retrieving image URL: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: <Widget>[
              if (widget.username.isNotEmpty) // Add this check to avoid null errors
                FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: query,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    dynamic data = snapshot.value;

                    if (data is Map) {
                      data['key'] = snapshot.key;
                      orders.add(data); // Store each order in the list
                      return FutureBuilder<String?>(
                        future: getImageUrl(data['itemImage']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Show a placeholder while waiting for the image URL
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
                                          // Padding of 30 seems excessive, you might want to adjust this value.
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
                      // Handle other cases, for example, if the data is not a Map
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
