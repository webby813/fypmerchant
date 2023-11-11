import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Firebase/update_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('History');

  String? uniqueKey;


  @override
  void initState() {
    super.initState();
    uniqueKey = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (query != null)
              FirebaseAnimatedList(
                shrinkWrap: true,
                query: query,
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                  Map data = snapshot.value as Map;
                  data['key'] = snapshot.key;
                  uniqueKey = data['key'].toString();
                  print(uniqueKey);

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
                                builder: (context) => ShowHistoryPage(uniqueKey: data['key'].toString(),
                              ),
                              )
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
                                          uniqueKey.toString(),
                                          style: TextStyle(
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
                    }, future: null,
                  );
                },
              )
          ],
        ),
      ),
    );
  }

// Function to show the AlertDialog
}


class ShowHistoryPage extends StatefulWidget {
  final String uniqueKey;

  const ShowHistoryPage({Key? key, required this.uniqueKey}) : super(key: key);

  @override
  State<ShowHistoryPage> createState() => _ShowHistoryPageState();
}

class _ShowHistoryPageState extends State<ShowHistoryPage> {
  String? username;
  String? imageUrl;
  String? userShared;
  String? uniqueKey;
  late DatabaseReference query = FirebaseDatabase.instance.ref().child('History');
  List<Map<dynamic, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    uniqueKey = widget.uniqueKey;
    query = FirebaseDatabase.instance.ref().child('History/$uniqueKey');
  }

  Future<String?> getImageUrl(String imageName) async {
    try {
      Reference imageRef = FirebaseStorage.instance.ref().child('Item/$imageName');
      String imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error retrieving image URL: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView(
        children: [
          Column(
            children: <Widget>[
              if (widget.uniqueKey.isNotEmpty) // Add this check to avoid null errors
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
