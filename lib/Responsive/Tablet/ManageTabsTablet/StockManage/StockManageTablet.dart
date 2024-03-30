import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/alertDialog_widget.dart';
import 'package:fypmerchant/Components/title_widget.dart';
import 'package:fypmerchant/Responsive/Tablet/ManageTabsTablet/StockManage/mainAreaStockManage.dart';
import '../../../../Color/color.dart';

class ManageStockPage extends StatefulWidget {
  const ManageStockPage({Key? key}) : super(key: key);

  @override
  State<ManageStockPage> createState() => _ManageStockPageState();
}

class _ManageStockPageState extends State<ManageStockPage> {
  // Retrieve categories from database
  /// Assume these are the retrieved values
  final List<String> categories = ["Hot Coffee", "Cold Drinks", "Pastries"];
  String selectedCategory = ""; // Initially no card selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TitleWidget.titleWhite("Manage Stock"),
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
                      print("add item");
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
                              title: Text('New Category'),
                              content: Form(
                                child: TextFormField(),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {},
                                  child: Text("Add"),
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

