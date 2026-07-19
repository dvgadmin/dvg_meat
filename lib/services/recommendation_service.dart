import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/product_model.dart';
import '../models/recommendation_model.dart';

class RecommendationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<ProductModel>> getRecommendations(
      String productId,
      ) async {
    try {
      /// Step 1 : Read Recommendations
      final recommendationSnapshot = await _firestore
          .collection("Products")
          .doc(productId)
          .collection("Recommendations")
          .where("active", isEqualTo: true)
 //         .orderBy("displayOrder")
          .get();

      if (recommendationSnapshot.docs.isEmpty) {
        return [];
      }

      List<ProductModel> products = [];

      /// Step 2 : Loop recommendation list
      for (var recommendationDoc in recommendationSnapshot.docs) {
print("Recommendation Data:");
        final recommendation = RecommendationModel.fromFirestore(
          recommendationDoc.data(),
        );
print("Recommendation Parsed");
        /// Step 3 : Read Product
        final productDoc = await _firestore
            .collection("Products")
            .doc(recommendation.productId)
            .get();

        if (!productDoc.exists) {
          continue;
        }

        final productData = productDoc.data()!;
        print(productData);
        /// Step 4 : Get Image URL
        String imageUrl = "";

        try {
          imageUrl = await _storage
              .ref(productData["imagePath"])
              .getDownloadURL();
        } catch (_) {}
print("Image URL Loaded");
        /// Step 5 : Convert to ProductModel
        products.add(
          ProductModel.fromFirestore(
            productDoc.id,
            productData,
            imageUrl,
          ),
        );
  print("ProductModel Created");

      }

      return products;
    } catch (e) {
      print("Recommendation Error : $e");
      return [];
    }
  }
}