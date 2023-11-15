import 'package:firebase_database/firebase_database.dart';


class UpdateUser{
  Future<void> updateUserInfo(String userid, String type, String newData) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref('User/$userid');
    try{
      ref.update(
          {
            type:newData
          }
      ).then((value) {
        // print("Insert Successfully");

      }).catchError((error){
        // print("Fail to insert");
      });
    }catch(error){
      // print(error);
    }
  }
}

class AcceptOrder{
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String currentTimeKey = DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> readCartData(String username) async {
    _databaseReference.child("Order").child(username).get().then((DataSnapshot snapshot) {
      // Check if the snapshot contains data
      if (snapshot.value != null) {
        // Convert the dynamic value to Map<dynamic, dynamic>
        Map<dynamic, dynamic>? cartData = snapshot.value as Map<dynamic, dynamic>?;
        if (cartData != null) {
          createNewDataset(cartData, username);
        } else {
          // print("Invalid data format for Cart data.");
        }
      } else {
        // print("Cart data is empty.");
      }
    }).catchError((error) {
      // print("Error reading cart data: $error");
    });
  }

  void createNewDataset(Map<dynamic, dynamic> cartData, username) async {
    try {
      // Here, you can create a new dataset in the Firebase Realtime Database
      // For example, if you want to store it under a new node named "NewCart":
      await _databaseReference.child("Pending/$username").set(cartData);
      // print("New dataset created successfully");
      remove(username);
        } catch (error) {
      // print("Error creating new dataset: $error");
    }
  }

  void remove(username) async{
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Order/$username');
    ref.remove();
  }
}

class RejectOrder{
  Future<void> rejectUserOrder(username) async{
      final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Order/$username');
      ref.remove();
  }
}


class PendingFinish{
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String currentTimeKey = DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> readCartData(String username) async {
    _databaseReference.child("Pending").child(username).get().then((DataSnapshot snapshot) {
      // Check if the snapshot contains data
      if (snapshot.value != null) {
        // Convert the dynamic value to Map<dynamic, dynamic>
        Map<dynamic, dynamic>? cartData = snapshot.value as Map<dynamic, dynamic>?;
        if (cartData != null) {
          createNewDataset(cartData, username);
        } else {
          // print("Invalid data format for Cart data.");
        }
      } else {
        // print("Cart data is empty.");
      }
    }).catchError((error) {
      // print("Error reading cart data: $error");
    });
  }

  void createNewDataset(Map<dynamic, dynamic> cartData, username) async {
    String currentTimeKey = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      // Here, you can create a new dataset in the Firebase Realtime Database
      // For example, if you want to store it under a new node named "NewCart":
      await _databaseReference.child("History/$username$currentTimeKey").set(cartData);
      // print("New dataset created successfully");
      remove(username);
        } catch (error) {
      // print("Error creating new dataset: $error");
    }
  }

  void remove(username) async{
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Pending/$username');
    ref.remove();
  }
}

