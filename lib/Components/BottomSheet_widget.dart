import 'package:flutter/material.dart';

class ProductBottomSheet extends StatefulWidget {
  final String imageName;
  final String title;
  final String price;
  
  const ProductBottomSheet({super.key, 
    required this.imageName,
    required this.title,
    required this.price,
  });
  
  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      // Add your bottom sheet UI here
      child: Column(
        children: [
          Image.asset(widget.imageName,),
          Text(widget.title),
          Text(widget.price)
        ],
      ),
    );
  }
}