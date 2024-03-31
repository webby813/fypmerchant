import 'package:fypmerchant/Color/color.dart';
import 'package:flutter/material.dart';

class TitleWidget {
  ///Title Widget
  static Widget blueTitle(String text) {
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

  static Widget whiteTitle(String text) {
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

class AppBarWidget {
  static Widget bartext(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: TextStyle(
          shadows: <Shadow>[
            Shadow(
              offset: const Offset(4.0, 4.0),
              blurRadius: 20.0,
              color: CustomColors.defaultWhite.withOpacity(0.5),
            ),
          ],
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: CustomColors.primaryColor,
        ),
      ),
    );
  }
}




