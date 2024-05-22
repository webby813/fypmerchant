import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';

TextEditingController password = TextEditingController();

class InputWidget{
  static Widget inputField(String hint, IconData iconData, var controller) {
    return SizedBox(
      height: 50,
      child: Material(
        elevation: 8,
        shadowColor: Colors.black87,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: controller,
          obscureText: (controller == password) ? true : false,
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            prefixIcon: Icon(iconData),
          ),
        ),
      ),
    );
  }

  static Widget stockInput(String name, String price, String description){
    return SizedBox(
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputWidget.manageInput(name),
          InputWidget.manageInput(price),
          InputWidget.description(description)
        ],
      ),
    );
  }

  ///product name and price
  static Widget manageInput(String text){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.secondaryWhite,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            height: 50,
            width: 200,
            child: TextField(
              decoration: InputDecoration(
                hintText: text,
                border: InputBorder.none,
                enabled: false
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Description
  static Widget description(String text){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.secondaryWhite,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 140,
            child: SingleChildScrollView(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16), // 设置文本样式
              ),
            ),
          ),
        ),
      ),
    );
  }

}