import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';

class ButtonWidget{
  static Widget buttonWidget(String title, onPressed) {
    return SizedBox(
      width: 170,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: const Color(0xFF2192FF),
          shape: const StadiumBorder(),
          elevation: 5,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: CustomColors.defaultWhite,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SimpleButton{
  static Widget buttonWidget(String title, onPressed){
    return SizedBox(
      width: 100,
      height: 40,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            Colors.blue, // Change color as needed
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


enum ShopState { Opening, Breaking, Closed }

class ShopStatusButton extends StatefulWidget {
  final ShopState initialShopState;

  const ShopStatusButton({Key? key, required this.initialShopState}) : super(key: key);

  @override
  _ShopStatusButtonState createState() => _ShopStatusButtonState();
}

class _ShopStatusButtonState extends State<ShopStatusButton> {
  late ShopState _currentShopState;

  @override
  void initState() {
    super.initState();
    _currentShopState = widget.initialShopState;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 40,
      child: TextButton(
        onPressed: () {
          setState(() {
            // Toggle between different shop states
            switch (_currentShopState) {
              case ShopState.Opening:
                _currentShopState = ShopState.Breaking;
                break;
              case ShopState.Breaking:
                _currentShopState = ShopState.Closed;
                break;
              case ShopState.Closed:
                _currentShopState = ShopState.Opening;
                break;
            }
          });
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            _getStateColor(_currentShopState),
          ),
        ),
        child: Text(
          _getStateText(_currentShopState),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getStateText(ShopState state) {
    switch (state) {
      case ShopState.Opening:
        return "Opening";
      case ShopState.Breaking:
        return "Breaking";
      case ShopState.Closed:
        return "Closed";
      default:
        return "";
    }
  }

  Color _getStateColor(ShopState state) {
    switch (state) {
      case ShopState.Opening:
        return Colors.green;
      case ShopState.Breaking:
        return Colors.yellow;
      case ShopState.Closed:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}