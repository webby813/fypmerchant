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

class AddUpdateDialog extends StatefulWidget {
  final String type;
  final onPressed;

  const AddUpdateDialog({Key? key, required this.type, required this.onPressed});

  @override
  State<AddUpdateDialog> createState() => _AddUpdateDialogState();
}

class _AddUpdateDialogState extends State<AddUpdateDialog> {
  String? _dropdownValue;
  @override
  Widget build(BuildContext context) {
    List<String> itemStatus = ['Available', 'Unavailable'];
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
                    SizedBox(
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
                  ],
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
            child: Text(widget.type),
            onPressed: () => widget.onPressed()
        ),
      ],
    );
  }
}
