import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key, required this.userimage});

  final String userimage;
  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            const Padding(padding: EdgeInsets.all(20)),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    userimage,
                    width: 180,
                    height: 170,
                    fit: BoxFit.cover,
                  ),
                ),
            )
          ],
    );
  }
}

