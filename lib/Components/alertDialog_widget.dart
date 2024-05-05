import 'package:flutter/material.dart';
import '../Color/color.dart';

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

  void _handlePress(){
    widget.onPressed(_itemName, _price, _description);
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.defaultWhite,
      scrollable: true,
      title: const Text("Product", textAlign: TextAlign.center),
      content: SizedBox(
        width: 800,
        child: Form(
          child: Column(
            children: <Widget>[
              Center(
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
                        ),
                      ),
                    ),
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
  late String docID;
  late String currentName;
  late String currentPrice;
  late String currentDescription;

  UpdateItemDialog({
    Key? key,
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

  void _handlePress() {
    widget.onPressed(widget.currentName, widget.currentPrice, widget.currentDescription);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      scrollable: true,
      title: const Text("Product", textAlign: TextAlign.center),
      content: SizedBox(
        width: 800,
        child: Form(
          child: Column(
            children: <Widget>[
              Center(
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
                        ),
                      ),
                    ),
                  ],
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
