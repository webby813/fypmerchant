import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/alertDialog_widget.dart';
import 'package:fypmerchant/Components/menu_widget.dart';
import 'package:fypmerchant/Components/textTitle_widget.dart';
import 'package:fypmerchant/Firebase/retrieve_data.dart';
import '../../../../Color/color.dart';
import '../../../../Components/inputField_widget.dart';
import '../../../../Components/spinner_widget.dart';
import '../../../../Firebase/create_data.dart';
import '../../../../Firebase/delete_data.dart';
import '../../../../Firebase/update_data.dart';

class ManageStockPage extends StatefulWidget {
  const ManageStockPage({Key? key}) : super(key: key);

  @override
  State<ManageStockPage> createState() => _ManageStockPageState();
}

class _ManageStockPageState extends State<ManageStockPage> {
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
        title: TitleWidget.whiteTitle("Manage Stock"),
        backgroundColor: CustomColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddItemDialog(
                    onPressed: (String imagePath, String imageName, String itemName, String price, String description) {
                      CreateData().createItem(context, imagePath, imageName, selectedCategory, itemName, price, description);
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
                            onLongPress: () {
                              setState(() {
                                selectedCategory = category;
                              });

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
    return Scaffold(
      backgroundColor: CustomColors.defaultWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.category.isEmpty)
              Spinner.loadingSpinner()
            else
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('items')
                    .doc(widget.category)
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
                          StockItemCardOnTablet(
                            item_picture:item['item_picture'],
                            item_name: item['item_name'],
                            price: item['price'], // Example price, replace with actual value
                            description: item['description'],
                            selectedCategory: widget.category,
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

          ],
        ),
      ),
    );
  }
}

///*****************************  StockItem Card  *****************************///
class StockItemCardOnTablet extends StatefulWidget {
  final String item_picture;
  final String item_name;
  final String price;
  final String description;
  final String selectedCategory;

  const StockItemCardOnTablet({
    Key? key,
    required this.item_picture,
    required this.item_name,
    required this.price,
    required this.description,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  _StockItemCardOnTabletState createState() => _StockItemCardOnTabletState();
}

class _StockItemCardOnTabletState extends State<StockItemCardOnTablet> {
  late Future<String?> _pictureUrlFuture;

  @override
  void initState() {
    super.initState();
    _pictureUrlFuture = RetrievePicture().loadItemPicture(widget.item_picture);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 15),
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red, // Change color to your preference
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white, // Change color to your preference
          ),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeleteItemDialog(selectedCategory: widget.selectedCategory, docID: widget.item_name);
            },
          );
        },
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => UpdateItemDialog(
                currentPicture: widget.item_picture,
                docID: widget.item_name,
                currentName: widget.item_name,
                currentPrice: widget.price,
                currentDescription: widget.description,
                onPressed: (String imagePath, String item_picture, String itemName, String price, String description) {
                  UpdateData().updateItem(context,imagePath, widget.item_picture, widget.selectedCategory, widget.item_name, itemName, price, description);
                },
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
                    padding: const EdgeInsets.all(20),
                    child: Card(
                      child: Container(
                        width: 180,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200], // Placeholder color
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FutureBuilder<String?>(
                            future: _pictureUrlFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Spinner.loadingSpinner();
                              } else if (snapshot.hasError) {
                                return const Icon(Icons.error);
                              } else if (snapshot.hasData) {
                                return Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return const Icon(Icons.error);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Product Details
                  // InputWidget.stockInput(widget.name, widget.price.toStringAsFixed(2), widget.description),
                  InputWidget.stockInput(widget.item_name, widget.price, widget.description),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

