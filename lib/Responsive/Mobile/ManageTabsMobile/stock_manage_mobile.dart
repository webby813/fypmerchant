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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton<String>(
                      isExpanded: true,
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

            Container(
              width: 360,
              height: 150,
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
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
                            item_picture: item['item_picture'],
                            item_name: item['item_name'],
                            price: item['price'],
                            description: item['description'],
                            selectedCategory: selectedCategory,
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

class StockItemCardOnMobile extends StatefulWidget {
  final String item_picture;
  final String item_name;
  final String price;
  final String description;
  final String selectedCategory;

  const StockItemCardOnMobile({
    Key? key,
    required this.item_picture,
    required this.item_name,
    required this.price,
    required this.description,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  State<StockItemCardOnMobile> createState() => _StockItemCardOnMobileState();
}

class _StockItemCardOnMobileState extends State<StockItemCardOnMobile> {
  late Future<String?> _pictureUrlFuture;

  @override
  void initState() {
    super.initState();
    _pictureUrlFuture = RetrievePicture().loadItemPicture(widget.item_picture);
  }

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
                  onPressed: (String? imagePath, String? item_picture, String itemName, String price, String description) {
                    UpdateData().updateItem(context, imagePath, item_picture, widget.selectedCategory, widget.item_name, itemName, price, description);
                  },
                ));
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FutureBuilder<String?>(
                            future: _pictureUrlFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Spinner.loadingSpinner();
                              } else if (snapshot.hasError) {
                                return Icon(Icons.error);
                              } else if (snapshot.hasData) {
                                return Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Icon(Icons.error);
                              }
                            },
                          ),
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