import 'package:flutter/material.dart';

class NumericKeypadDialog extends StatefulWidget {
  const NumericKeypadDialog({Key? key}) : super(key: key);

  @override
  _NumericKeypadDialogState createState() => _NumericKeypadDialogState();
}

class _NumericKeypadDialogState extends State<NumericKeypadDialog> {
  String input = '';

  void _onKeyPress(String key) {
    setState(() {
      if (input.length < 4) {
        input += key;
      }
    });
  }

  void _onBackspacePress() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  void _onOkPress() {
    Navigator.of(context).pop(input); // Return the input
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Number'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            input.padRight(4, '_'),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildNumpad(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _onOkPress,
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        _buildRow(['4', '5', '6']),
        _buildRow(['7', '8', '9']),
        _buildRow(['', '0', '<']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        return _buildKey(key);
      }).toList(),
    );
  }

  Widget _buildKey(String key) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 70,
        height: 70,
        child: ElevatedButton(
          onPressed: key.isEmpty
              ? null
              : () {
            if (key == '<') {
              _onBackspacePress();
            } else {
              _onKeyPress(key);
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
          ),
          child: Text(
            key,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
