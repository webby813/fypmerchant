import 'package:flutter/material.dart';

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
