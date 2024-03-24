import 'package:flutter/material.dart';
import '../../Components/button_widget.dart';

class ShopStatusManage extends StatefulWidget {
  const ShopStatusManage({Key? key}) : super(key: key);

  @override
  _ShopStatusManageState createState() => _ShopStatusManageState();
}

class _ShopStatusManageState extends State<ShopStatusManage> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              const Text(
                "Shop Status",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              Expanded(child: Container()),

              Container(
                margin: const EdgeInsets.only(right: 60),
                width: 100,
                height: 40,
                child: const ShopStatusButton(initialShopState: ShopState.Opening),
              ),
            ],
          ),

          const SizedBox(height: 15,),

          Row(
            children: [
              const Text(
                "Business Operating Period",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              Expanded(child: Container()),

              Container(
                margin: const EdgeInsets.only(right: 60),
                width: 100,
                height: 40,
                child: SimpleButton.buttonWidget("Modify", (){}),
              ),
            ],
          )
        ],
      ),
    );
  }
}
