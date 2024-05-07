import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateData {
  Future<void> createCategory(BuildContext context, String newCategory, TextEditingController newCategoryController, Function() onCategoryCreated) async {
    try {
      CollectionReference collRef = FirebaseFirestore.instance.collection("items");
      await collRef.doc(newCategory).set({
        'categoryID': newCategory,
      });

      onCategoryCreated();
      Navigator.of(context).pop();
      newCategoryController.clear();
    } catch (e) {
      // print('Error creating category: $e');
    }
  }

  Future<void> createItem(BuildContext context, String imagePath, String imageName, String type, String _itemName, String _price, String _description) async {
    try {
      final storage = FirebaseStorage.instance.ref('Items/$imageName');
      DocumentReference typeDocRef = FirebaseFirestore.instance.collection("items").doc(type);

      File imageFile = File(imagePath);
      await storage.putFile(imageFile);

      await typeDocRef.collection('content').doc(_itemName).set({
        'item_picture': imageName,
        'item_name': _itemName,
        'price': _price,
        'description': _description,
        'category': type,
      });

      Navigator.of(context).pop();
    } catch (e) {
      // Handle error
      print(e);
    }
  }
}

class ImageData {
  final String path;
  final String name;

  ImageData(this.path, this.name);
}

class AddPhoto {
  final ImagePicker _picker = ImagePicker();

  Future<void> selectImageFromGallery(Function(ImageData?) onImageSelected) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      onImageSelected(ImageData(image.path, image.name));
    } else {
      onImageSelected(null);
    }
  }

}

