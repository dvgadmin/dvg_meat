import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreImporterRecommendation {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> importProducts() async {
    try {

  final List<Map<String, dynamic>> recommendations = [
      {
        "productDocId": "Tomato",
        "productId": "Tomato",
        "displayOrder": 1,
        "active": true,
      },
	     {
        "productDocId": "Tomato",
        "productId": "Tomato",
        "displayOrder": 2,
        "active": true,
      },
	     {
        "productDocId": "Tomato",
        "productId": "Tomato",
        "displayOrder": 3,
        "active": true,
      },
	  	     {
        "productDocId": "Tomato",
        "productId": "Tomato",
        "displayOrder": 5,
        "active": true,
      },
	  	{
        "productDocId": "Tomato",
        "productId": "Tomato",
        "displayOrder": 6,
        "active": true,
      }
  ];

   WriteBatch batch = _firestore.batch();

   for (final item in recommendations) {

     final doc = _firestore
      .collection("Products")
      .doc(item["productDocId"])
      .collection("Recommendations")
      .doc(item["productId"]);

       batch.set(doc, {
            "productId": item["productId"],
            "displayOrder": item["displayOrder"],
            "active": item["active"],
          });
    }

    await batch.commit();

    print("Recommendations imported successfully.");
  }
    catch (e) {
      print("Error importing products: $e");
    }
  }
}