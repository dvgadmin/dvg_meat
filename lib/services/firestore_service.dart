import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/product_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Get Products by Category
  static Future<List<ProductModel>> getProducts(
      String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection("Products")
          .where(
            "categoryId",
            isEqualTo: categoryId.toLowerCase(),
          )
          .where(
            "active",
            isEqualTo: true,
          )
          .orderBy("displayOrder")
          .get();

      List<ProductModel> products = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();

        String imageUrl = "";

        try {
          imageUrl = await _storage
              .ref(data["imagePath"])
              .getDownloadURL();
        } catch (_) {
          imageUrl = "";
        }

        products.add(
          ProductModel.fromFirestore(
            doc.id,
            data,
            imageUrl,
          ),
        );
      }

      return products;
    } catch (e) {
      print("Firestore Error : $e");
      return [];
    }
  }
}