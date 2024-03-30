import 'package:flutter/material.dart';
import '../Color/color.dart';
import '../Firebase/update_data.dart';

class AlertDialogWidget extends StatelessWidget {

  const AlertDialogWidget({super.key, required this.Title, required this.content});

  final String Title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(Title),
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

class AlertToChangeDialog extends StatelessWidget {

  AlertToChangeDialog({super.key, required this.title, required this.content, required this.userid, required this.type, required this.backText, required this.confirmText});


  final String title;
  final String content;

  final String type;
  final String userid;
  final TextEditingController newData = TextEditingController();

  final backText;
  final confirmText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(title),
      content: Text(content),
      actions: [
        TextField(
          controller: newData,
          decoration: const InputDecoration(
              border: OutlineInputBorder(
              )
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(padding: EdgeInsets.all(0)),
            TextButton(
              child: Text(backText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            const Padding(padding: EdgeInsets.all(0)),
            TextButton(
              child: Text(confirmText),
              onPressed: () {
                UpdateUser().updateUserInfo(userid, type, newData.text);
                print(newData.text);
              },
            ),
          ],
        )
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
