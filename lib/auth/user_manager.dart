import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManager {
  void storeUserToDB(User user) {
    FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "email": user.email,
    });
  }
}
