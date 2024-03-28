import 'package:flutter/material.dart';
import '../../../Color/color.dart';
import '../../../Components/barTitle_widget.dart';

class ManageStockMobile extends StatefulWidget {
  const ManageStockMobile({Key? key}) : super(key: key);

  @override
  State<ManageStockMobile> createState() => _ManageStockMobileState();
}

class _ManageStockMobileState extends State<ManageStockMobile> {
  List<String> list = <String>["Hot Coffee", "ColdCoffee", "Pastries"];
  String dropdownValue = "Hot Coffee";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.defaultWhite,
        title: BarTitle.appBarText("Manage Stock"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 33),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        if (value != null) {
                          setState(() {
                            dropdownValue = value;
                          });
                        }
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                Expanded(
                  flex: 0,
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: (){

                      },
                    )
                )
              ],
            ),

            const StockItemCardOnMobile(name: "name", price: 4.90, description: "description"),
            const StockItemCardOnMobile(name: "name", price: 4.90, description: "description"),
            const StockItemCardOnMobile(name: "name", price: 4.90, description: "description"),
          ],
        ),
      ),
    );
  }
}

class StockItemCardOnMobile extends StatefulWidget {
  final String name;
  final double price;
  final String description;
  const StockItemCardOnMobile({
    Key? key,
    required this.name,
    required this.price,
    required this.description,
  }) : super(key: key);

  @override
  State<StockItemCardOnMobile> createState() => _StockItemCardOnMobileState();
}

class _StockItemCardOnMobileState extends State<StockItemCardOnMobile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          color: CustomColors.warningRed,
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: CustomColors.defaultWhite,
          ),
        ),
        onDismissed: (direction) {},
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: CustomColors.defaultWhite,
                scrollable: true,
                title: const Text("Product", textAlign: TextAlign.center),
                content: SizedBox(
                  width: 800,
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Card(
                              child: Container(
                                width: 130,
                                height: 125,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Latte",
                            border: InputBorder.none,
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "4.90",
                            border: InputBorder.none,
                          ),
                        ),
                        SizedBox(
                          height: 140,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "text",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () {},
                  ),
                ],
              ),
            );
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      child: Container(
                        width: 110,
                        height: 105,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.price.toStringAsFixed(2),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.description,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
