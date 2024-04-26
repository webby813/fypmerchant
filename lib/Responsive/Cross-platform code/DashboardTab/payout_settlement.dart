import 'package:flutter/material.dart';
import '../../../Color/color.dart';
import '../../../Components/dropDown_widget.dart';

class Settlement extends StatefulWidget {
  const Settlement({Key? key}) : super(key: key);

  @override
  State<Settlement> createState() => _SettlementState();
}

class _SettlementState extends State<Settlement> {
  List<String> options = ['January', 'February', 'March'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: CustomDropdown(items: options),
              )
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const SettlementItems();
            },
          ),
        ),
      ],
    );
  }
}

class SettlementItems extends StatelessWidget {
  const SettlementItems({Key? key}) : super(key: key);

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
                        "5 February 2025",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: const Text(
                      "+ RM600.50",
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