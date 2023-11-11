import 'package:fypmerchant/Color/color.dart';
import 'package:flutter/material.dart';

class ButtonWidget{
  static Widget buttonWidget(String title, onPressed) {
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: const StadiumBorder(),
          primary: const Color(0xFF2192FF),
          elevation: 5,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SecondButtonWidget{
  static Widget buttonWidget(String title, onPressed) {
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: const StadiumBorder(),
          primary: CustomColors.secondaryColor,
          elevation: 5,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}