import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';

class DivideWidget extends StatelessWidget {
  const DivideWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
      child: Divider(
        color: CustomColors.lightGrey,
        thickness: 1,
        indent: 20,
        endIndent: 20,
      ),
    );
  }
}
