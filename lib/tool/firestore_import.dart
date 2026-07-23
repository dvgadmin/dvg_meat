import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreImporter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> importProducts() async {
    try {

  List<Map<String, dynamic>> products = [
  {
  "active": true,
  "category": "vegitables",
  "categoryId": "",
  "description_en": "Ginger",
  "description_ta": "இஞ்சி",
  "displayOrder": 8,
  "imageName": "ginger.png",
  "imagePath": "vegitables/ginger.png",
  "isBestSeller": true,
  "name_en": "ginger",
  "name_ta": "இஞ்சி",
  "price": 120.0,
  "rating": 4.6,
  "ratingCount": 35,
  "stock": true,
  "unit": "kg"
}
  ];

   WriteBatch batch = _firestore.batch();

   for (final product in products) {
      final String docId = product["name_en"].toString();
      final doc = _firestore.collection("Products").doc(docId);
      batch.set(doc, product);
}

    await batch.commit();
    print("Products imported successfully.");
  }
    catch (e) {
      print("Error importing products: $e");
    }
  }
}