import 'package:fypmerchant/Color/color.dart';
import 'package:flutter/material.dart';

class ButtonWidget{
  static Widget buttonWidget(String title, onPressed) {
    return SizedBox(
      width: 180,
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
          padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: CustomColors.secondaryColor,
          shape: const StadiumBorder(),
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