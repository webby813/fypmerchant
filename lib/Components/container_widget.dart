import 'package:fypmerchant/Components/BottomSheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:fypmerchant/Color/color.dart';

import 'inputField_widget.dart';

class StockItemCard extends StatelessWidget {
  final name;
  final price;
  final description;
  const StockItemCard({super.key, required this.name, required this.price, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 15),
      child: Card(
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: CustomColors.defaultWhite,
            borderRadius: BorderRadius.circular(15),
          ),

          child: Row(
            children: [
              ///Product Photo
              Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  child: Container(
                    width: 180,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12),
                      color: CustomColors.lightGrey,
                    ),
                  ),
                ),
              ),

              InputWidget.StockInput(name, price, description),

              // Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 55, bottom: 250),
              //       child: IconButton(
              //         onPressed: () {},
              //         icon: const Icon(Icons.cancel_outlined),
              //         color: CustomColors.warningRed,
              //         iconSize: 30,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}



class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const CustomContainer({super.key, required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

///Custome Card use for Recommend list in homePage.dart
class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.imageName, required this.title, required this.price});

  final String imageName;
  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          GestureDetector(
          onTap: (){
            // print('test');
          },
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      imageName,
                      width: 180,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                      fontSize: 18
                    ),
                    ),

                    Text(
                        'RM $price',
                      style: const TextStyle(
                        fontSize: 14
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


///CustomMenuCard use to review products in Menu
class CustomMenuCard extends StatelessWidget {
  const CustomMenuCard({super.key, required this.imageName, required this.title, required this.price});

  final String imageName;
  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(context: context,
            isScrollControlled: true,
            builder: (BuildContext context){
          return ProductBottomSheet(
            imageName: imageName,
            title: title,
            price: price,
          );
            }
            );
      },
      child: Card(
        shadowColor: CustomColors.defaultWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(5)),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  imageName,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'RM $price',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key, required this.title, required this.icon, required this.onPress, this.endIcon = true, this.textColor,}) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {


    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: CustomColors.lightGrey.withOpacity(0.1),
        ),
        child: Icon(icon, color: CustomColors.primaryColor),
      ),
      title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor)
      ),
      trailing: endIcon?
      Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
        child: const Icon(Icons.keyboard_double_arrow_right),
      ) : null,
    );
  }
}





