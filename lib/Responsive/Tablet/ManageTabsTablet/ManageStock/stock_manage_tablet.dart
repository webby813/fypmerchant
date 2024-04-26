import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/alertDialog_widget.dart';
import 'package:fypmerchant/Components/dropDown_widget.dart';
import 'package:fypmerchant/Components/textTitle_widget.dart';
import 'package:fypmerchant/Firebase/retrieve_data.dart';
import '../../../../Color/color.dart';
import '../../../../Components/inputField_widget.dart';
import '../../../../Firebase/create_data.dart';

class ManageStockPage extends StatefulWidget {
  const ManageStockPage({Key? key}) : super(key: key);

  @override
  State<ManageStockPage> createState() => _ManageStockPageState();
}

class _ManageStockPageState extends State<ManageStockPage> {
  final List<String> categories = [];
  String selectedCategory = "";

  TextEditingController newCategory = TextEditingController();

  @override
  void initState(){
    super.initState();
    RetrieveData().retrieveCategories().then((retrievedCategories) {
      setState(() {
        categories.addAll(retrievedCategories);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TitleWidget.whiteTitle("Manage Stock"),
        backgroundColor: CustomColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddUpdateDialog(
                    type: "Add",
                    onPressed: () {
                      // print("add item");
                    },
                  );
                },
              );
            },
            icon: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              alignment: Alignment.topLeft,
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('New Category'),
                              content: Form(
                                child: TextFormField(
                                  controller: newCategory,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    CreateData().createCategory(context, newCategory.text, newCategory);
                                  },
                                  child: const Text("Add"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.add),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GestureDetector(
                            onLongPress: (){
                              setState(() {
                                selectedCategory = category;
                              });
                              MenuWidget().categoryActionMenu(context, selectedCategory);
                              // print('long pressed');
                            },

                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Card(
                              color: selectedCategory == category
                                  ? CustomColors.deepGreen
                                  : CustomColors.defaultWhite,
                              child: SizedBox(
                                width: 400,
                                height: 70,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: selectedCategory == category
                                          ? CustomColors.defaultWhite
                                          : CustomColors.defaultBlack,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 12,
            child: MainAreaStockManage(
              category: selectedCategory,
            ),
          ),
        ],
      ),
    );
  }
}

///*****************************  MAIN AREA *****************************///
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


///*****************************  StockItem Card  *****************************///
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
                InputWidget.stockInput(widget.name, widget.price.toStringAsFixed(2), widget.description),

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

