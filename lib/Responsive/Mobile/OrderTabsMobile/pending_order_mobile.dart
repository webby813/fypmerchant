import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Firebase/pending_order.dart';
import 'package:fypmerchant/Firebase/update_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PendingOrderMobile extends StatefulWidget {
  const PendingOrderMobile({Key? key}) : super(key: key);

  @override
  State<PendingOrderMobile> createState() => _PendingOrderMobileState();
}

class _PendingOrderMobileState extends State<PendingOrderMobile> {
  final DatabaseReference query = FirebaseDatabase.instance.ref().child('Pending');

  String? username;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ViewPendingOrder()
    );
  }
}

