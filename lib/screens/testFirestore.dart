import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestFirestore extends StatefulWidget {
  const TestFirestore({super.key});

  @override
  State<TestFirestore> createState() => _TestFirestoreState();
}

class _TestFirestoreState extends State<TestFirestore> {
  @override
  void initState() {
    super.initState();
    testFirebase();
  }

  Future<void> testFirebase() async {
  try {
    await FirebaseFirestore.instance
        .collection("TestFirestore")
        .doc("test2")
        .set({
      "name": "Working",
      "value": 200,
    });

    print("WRITE SUCCESS");

    final doc = await FirebaseFirestore.instance
        .collection("TestFirestore")
        .doc("test2")
        .get();

    print(doc.data());
  } on FirebaseException catch (e) {
    print(e.code);
    print(e.message);
  }
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Testing Firestore...",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}