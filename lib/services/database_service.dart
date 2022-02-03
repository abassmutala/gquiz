import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getUsers() async {
    int count = 0;
    QuerySnapshot users = await _firestore
        .collection("User")
        .orderBy("score", descending: true)
        .get();
    debugPrint(users.docs.length.toString());
    return users.docs;
  }
}
