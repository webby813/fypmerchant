import 'package:flutter/material.dart';

class TextWidget{
  static Widget textWidget(String text){
    return Text(
      text,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold, color: Color(0xFFD7BFA6)),
    );
  }
}