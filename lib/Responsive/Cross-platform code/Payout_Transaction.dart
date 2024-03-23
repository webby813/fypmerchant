import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List<String> options = ['Today', 'Yesterday', 'Weekly']; // 更短的变量名

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const TransactionItems();
            },
          ),
        ),
      ],
    );
  }
}

class TransactionItems extends StatelessWidget {
  const TransactionItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Show detail of list tile will build in the future
      },
      child: SizedBox(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: CustomColors.lightGrey,
              child: Row(
                children: [
                  const Expanded(
                    child: ListTile(
                      title: Text(
                        "Order#001",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text("14.30 p.m."),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: const Text(
                      "RM4.50",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
