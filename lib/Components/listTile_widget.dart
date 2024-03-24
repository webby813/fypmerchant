import 'package:flutter/material.dart';
import '../Color/color.dart';

class ListTileTitle{
  static Widget tileTitle({
    required String title
  }){
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: CustomColors.primaryColor,
                    width: 2.0
                )
            )
        ),
        child:Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
        ),
      ),
    );
  }
}

class CustomListTile {
  static Widget tile({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: onTap,
    );
  }
}