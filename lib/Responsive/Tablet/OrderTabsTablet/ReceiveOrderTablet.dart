import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../Components/cart_widget.dart';

class ReceiveOrderTablet extends StatefulWidget {
  final Function(String?) onCardTap;

  const ReceiveOrderTablet({Key? key, required this.onCardTap}) : super(key: key);

  @override
  State<ReceiveOrderTablet> createState() => _ReceiveOrderTabletState();
}

class _ReceiveOrderTabletState extends State<ReceiveOrderTablet> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('Order');

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ViewOrderTablet(maxWidth: maxWidth, onCardTap: widget.onCardTap),
          ],
        ),
      ),
    );
  }
}

class ViewOrderTablet extends StatefulWidget {
  final double? maxWidth;
  final Function(String?) onCardTap;

  const ViewOrderTablet({Key? key, this.maxWidth, required this.onCardTap}) : super(key: key);

  @override
  State<ViewOrderTablet> createState() => _ViewOrderTabletState();
}

class _ViewOrderTabletState extends State<ViewOrderTablet> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('Order');

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
                      print('Card tapped! Username: $username');
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
              future: null,
            );
          },
        )
      ],
    );
  }
}

