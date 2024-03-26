import 'package:fypmerchant/Color/color.dart';
import 'package:flutter/material.dart';

class TitleWidget {
  ///Title Widget
  static Widget titleBlue(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: Text(
        text,
        style: TextStyle(
          shadows: <Shadow>[
            Shadow(
              offset: const Offset(3.0, 3.0),
              blurRadius: 20.0,
              color: Colors.greenAccent.withOpacity(0.5),
            ),
          ],
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: CustomColors.primaryColor,
        ),
      ),
    );
  }

  static Widget titleWhite(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: Text(
        text,
        style: TextStyle(
          shadows: <Shadow>[
            Shadow(
              offset: const Offset(3.0, 3.0),
              blurRadius: 10.0,
              color: Colors.greenAccent.withOpacity(0.2),
            ),
          ],
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: CustomColors.defaultWhite,
        ),
      ),
    );
  }
}

class SubTitle{
  static subTitle(String text){
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,0,16,16),
      // padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontStyle: FontStyle.normal,
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: CustomColors.defaultBlack
        ),
      ),
    );
  }
}

class OrderTitle{
  static orderTitle(String text){
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 16, 16),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18
      ),
    ),
    );
  }
}

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
