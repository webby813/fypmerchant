import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';
import 'package:fypmerchant/Components/container_widget.dart';

import '../../../../Components/inputField_widget.dart';

class MainAreaStockManage extends StatefulWidget {
  final String category;

  const MainAreaStockManage({Key? key, required this.category})
      : super(key: key);

  @override
  _MainAreaStockManageState createState() => _MainAreaStockManageState();
}

class _MainAreaStockManageState extends State<MainAreaStockManage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CustomColors.defaultWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Widget in container_widget.dart, StockItemCard
            StockItemCardOnTablet(name: "name", price: 4.90, description: "description"),
            StockItemCardOnTablet(name: "name", price: 4.90, description: "description"),
            StockItemCardOnTablet(name: "name", price: 4.90, description: "description"),
          ],
        )
      ),
    );
  }
}

class StockItemCardOnTablet extends StatefulWidget {
  final String name;
  final double price;
  final String description;

  const StockItemCardOnTablet({
    Key? key,
    required this.name,
    required this.price,
    required this.description,
  }) : super(key: key);

  @override
  _StockItemCardOnTabletState createState() => _StockItemCardOnTabletState();
}

class _StockItemCardOnTabletState extends State<StockItemCardOnTablet> {
  String? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    List<String> itemStatus = ['Available', 'Unavailable'];

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 15),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          color: CustomColors.warningRed,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete,
            color: CustomColors.defaultWhite,
          ),
        ),
        onDismissed: (direction) {
          // Implement delete functionality here
        },
        child: Card(
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),

            child: Row(
              children: [
                // Product Photo
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    child: Container(
                      width: 180,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ),

                // Product Details
                InputWidget.StockInput(widget.name, widget.price.toStringAsFixed(2), widget.description),

                // Change status of product
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: SizedBox(
                    width: 105,
                    child: DropdownButton<String>(
                      value: _dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      items: itemStatus.map((String dropdownValue) {
                        return DropdownMenuItem(
                          value: dropdownValue,
                          child: Text(dropdownValue,
                            style: const TextStyle(
                                fontSize: 13
                            ),
                          ),
                        );
                      }).toList(),
                      hint: const Text("Status"),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue = newValue;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

