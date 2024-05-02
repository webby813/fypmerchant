import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Color/color.dart';
import '../../../Components/alertDialog_widget.dart';
import '../../../Components/container_widget.dart';
import '../../../Components/menu_widget.dart';
import '../../../Components/spinner_widget.dart';
import '../../../Components/textTitle_widget.dart';
import '../../../Firebase/create_data.dart';
import '../../../Firebase/delete_data.dart';
import '../../../Firebase/retrieve_data.dart';
import '../../../Firebase/update_data.dart';

class ManageStockMobile extends StatefulWidget {
  const ManageStockMobile({Key? key}) : super(key: key);

  @override
  State<ManageStockMobile> createState() => _ManageStockMobileState();
}

class _ManageStockMobileState extends State<ManageStockMobile> {
  final List<String> categories = [];
  String selectedCategory = "";

  TextEditingController newCategory = TextEditingController();

  void _updateCategories(List<String> retrievedCategories) {
    setState(() {
      categories.clear();
      categories.addAll(retrievedCategories);
      if (!categories.contains(selectedCategory) && categories.isNotEmpty) {
        selectedCategory = categories[0];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    RetrieveData().retrieveCategories().then((retrievedCategories) {
      _updateCategories(retrievedCategories);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.defaultWhite,
        title: AppBarWidget.bartext("Manage Stock"),
        actions: [
          IconButton(
            onPressed: () {
              MenuWidget(
                onUpdateCategory: (newCategoryId) {
                  UpdateData().updateCategory(
                    context,
                    selectedCategory,
                    newCategoryId,
                        () {
                      RetrieveData().retrieveCategories().then((retrievedCategories) {
                        _updateCategories(retrievedCategories);
                      });
                    },
                  );
                },
                onDeleteCategory: (categoryToDelete) {
                  DeleteData().deleteCategory(
                    context,
                    categoryToDelete,
                        () {
                      RetrieveData().retrieveCategories().then((retrievedCategories) {
                        _updateCategories(retrievedCategories);
                      });
                    },
                  );
                },
              ).categoryActionMenu(context, selectedCategory);
            },
            icon: const Icon(Icons.more_horiz),
          )

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                    padding: const EdgeInsets.symmetric(horizontal: 10), // Adjust padding as needed
                    child: DropdownButton<String>(
                      isExpanded: true, // Allow the dropdown button to expand to fit its parent
                      value: selectedCategory,
                      icon: const Icon(Icons.filter_alt),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                      items: categories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
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
                                  CreateData().createCategory(context, newCategory.text, newCategory, () {
                                    setState(() {
                                      categories.clear();
                                      RetrieveData().retrieveCategories().then((retrievedCategories) {
                                        _updateCategories(retrievedCategories);
                                      });
                                    });
                                  });
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            if (selectedCategory.isEmpty)
              Spinner.loadingSpinner()
            else
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('items')
                    .doc(selectedCategory)
                    .collection('content')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Spinner.loadingSpinner();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final List<Widget> itemWidgets = [];
                    final items = snapshot.data?.docs.reversed.toList();
                    if (items != null) {
                      for (var item in items) {
                        itemWidgets.add(
                          StockItemCardOnMobile(
                            item_name: item['item_name'],
                            price: item['price'], // Example price, replace with actual value
                            description: item['description'],
                            category: selectedCategory,
                          ),
                        );
                      }
                    }
                    return Column(
                      children: itemWidgets,
                    );
                  }
                },
              ),

            Container(
              width: 360,
              height: 150,
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddUpdateDialog(
                        action: "Add",
                        onPressed: (String itemName, String price, String description) {
                          print(itemName);
                          print(price);
                          print(description);
                          CreateData().createItem(context, selectedCategory, itemName, price, description);
                        },
                      );
                    },
                  );
                },
                child: DashedBorder(
                  strokeWidth: 2,
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'Tap here to add item',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StockItemCardOnMobile extends StatefulWidget {
  final String item_name;
  final String price;
  final String description;
  final String category;

  const StockItemCardOnMobile({
    Key? key,
    required this.item_name,
    required this.price,
    required this.description,
    required this.category,
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
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) => AddUpdateDialog(
                action: "Update",
                onPressed: (){
                  print(widget.category);
                },
              )
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
                              widget.item_name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              // widget.price.toStringAsFixed(2),
                              widget.price,
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
