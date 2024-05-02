import 'package:flutter/material.dart';

class Spinner{
  static Widget loadingSpinner(){
    return const Center(
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(200),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ),
    );
  }
}