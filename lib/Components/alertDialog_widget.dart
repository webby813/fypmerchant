import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Components/spinner_widget.dart';
import 'package:fypmerchant/Firebase/delete_data.dart';
import '../Color/color.dart';
import '../Firebase/create_data.dart';
import '../Firebase/retrieve_data.dart';

class AlertDialogWidget extends StatelessWidget {

  const AlertDialogWidget({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class AddItemDialog extends StatefulWidget {
  final onPressed;

  const AddItemDialog({Key? key,
    required this.onPressed});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  String? _itemName;
  String? _price;
  String? _description;
  String? imagePath;
  String? item_picture;

  void _handlePress(){
    widget.onPressed(imagePath, item_picture, _itemName, _price, _description);
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.defaultWhite,
      scrollable: true,
      title: const Text("Add Product", textAlign: TextAlign.center),
      content: SizedBox(
        width: 800,
        child: Form(
          child: Column(
            children: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await AddPhoto().selectImageFromGallery((imageData) {
                          if (imageData != null) {
                            setState(() {
                              imagePath = imageData.path;
                              item_picture = imageData.name;
                              print(imagePath);
                              print(item_picture);
                            });
                          }
                        });
                      },
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
                            child: imagePath?.isNotEmpty == true
                                ? Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),

              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Item (Americano)",
                  border: InputBorder.none,
                ),
                onChanged: (value){
                  setState(() {
                    _itemName = value;
                  });
                },
                initialValue: _itemName,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Price (ex. 5.60)",
                  border: InputBorder.none,
                ),
                onChanged: (value){
                  setState(() {
                    _price = value;
                  });
                },
              ),
              SizedBox(
                height: 140,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Description",
                    border: InputBorder.none,
                  ),
                  onChanged: (value){
                    setState(() {
                      _description = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            child: Text("Add"),
            onPressed: _handlePress,
        ),
      ],
    );
  }
}

class UpdateItemDialog extends StatefulWidget {
  final onPressed;
  late String currentPicture;
  late String docID;
  late String currentName;
  late String currentPrice;
  late String currentDescription;

  UpdateItemDialog({
    Key? key,
    required this.currentPicture,
    required this.docID,
    required this.currentName,
    required this.currentPrice,
    required this.currentDescription,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<UpdateItemDialog> createState() => _UpdateItemDialogState();
}

class _UpdateItemDialogState extends State<UpdateItemDialog> {
  late Future<String?> _pictureUrlFuture;
  String? imagePath;
  String? item_picture;

  @override
  void initState() {
    super.initState();
    _pictureUrlFuture = RetrievePicture().loadItemPicture(widget.currentPicture);
  }
  @override
  void _handlePress() {
    widget.onPressed(imagePath, item_picture, widget.currentName, widget.currentPrice, widget.currentDescription);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      scrollable: true,
      title: Text("Update " + widget.docID, textAlign: TextAlign.center),
      content: SizedBox(
        width: 800,
        child: Form(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: ()async{
                  await AddPhoto().selectImageFromGallery((imageData) {
                    if (imageData != null) {
                      setState(() {
                        imagePath = imageData.path;
                        item_picture = imageData.name;
                        print(imagePath);
                        print(item_picture);
                      });
                    }
                  });
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
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
                    ],
                  ),
                ),
              ),

              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Item (Americano)",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    widget.currentName = value;
                  });
                },
                initialValue: widget.currentName,
              ),

              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Price (ex. 5.60)",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    widget.currentPrice = value;
                  });
                },
                initialValue: widget.currentPrice,
              ),

              SizedBox(
                height: 140,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Description",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.currentDescription = value;
                    });
                  },
                  initialValue: widget.currentDescription,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text("Update"),
          onPressed: _handlePress,
        ),
      ],
    );
  }
}

class DeleteItemDialog extends StatefulWidget {
  final selectedCategory;
  final docID;

  DeleteItemDialog({
    Key? key,
    required this.selectedCategory,
    required this.docID,
  }) : super(key: key);

  @override
  State<DeleteItemDialog> createState() => _DeleteItemDialogState();
}

class _DeleteItemDialogState extends State<DeleteItemDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.secondaryWhite,
      title: Text("Delete " + widget.docID),
      content: Text("Are you sure you want to remove " +  widget.docID),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        TextButton(
          child: const Text('Delete'),
          onPressed: () {
            print(widget.docID);
            DeleteData().deleteItem(widget.selectedCategory, widget.docID);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

