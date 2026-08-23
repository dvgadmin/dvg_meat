import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/product_model.dart';
import '../models/recommendation_model.dart';
import 'firestore_service.dart';

class RecommendationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Returns recommendation products for the selected cooking option
  Future<List<ProductModel>> getRecommendationsForCooking({
    required String productId,
    required String cookingOptionId,
  }) async {
    try {
      // Step 1: Load recommendation document IDs
      final recommendationSnapshot = await _firestore
          .collection('Products')
          .doc(productId)
          .collection('CookingOptions')
          .doc(cookingOptionId)
          .collection('Recommendations')
          .where('active', isEqualTo: true)
          .orderBy('displayOrder')
          .get();

      if (recommendationSnapshot.docs.isEmpty) {
        return [];
      }

      // Step 2: Load all products in parallel
      final futures = recommendationSnapshot.docs.map((doc) async {
        final recommendation =
            RecommendationModel.fromFirestore(doc);
return await FirestoreService.getProductById(
  recommendation.productId,
);
//         final productSnapshot = await _firestore
//             .collection('Products')
//             .doc(recommendation.productId)
//             .get();

//         if (!productSnapshot.exists) {
//           return null;
//         }

//         final productData = productSnapshot.data()!;

//         String imageUrl = '';

// try {
//   imageUrl = await _storage
//       .ref(productData['imagePath'])
//       .getDownloadURL();
// } catch (_) {
//   imageUrl = '';
// }

// return ProductModel.fromFirestore(
//   productSnapshot.id,
//   productData,
//   imageUrl,
// );
      });

      final products = await Future.wait(futures);

      return products.whereType<ProductModel>().toList();
    } catch (e) {
      print('RecommendationService Error: $e');
      return [];
    }
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// import '../models/product_model.dart';
// import '../models/recommendation_model.dart';


// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/product_model.dart';
// import '../models/recommendation_model.dart';

// class RecommendationService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Existing recommendation method
//   Future<List<ProductModel>> getRecommendations(String productId) async {
//     try {
//       final recommendationSnapshot = await _firestore
//           .collection("Products")
//           .doc(productId)
//           .collection("Recommendations")
//           .where("active", isEqualTo: true)
//           .orderBy("displayOrder")
//           .get();

//       List<ProductModel> products = [];

//       for (final recommendationDoc in recommendationSnapshot.docs) {
//         final recommendation = RecommendationModel.fromFirestore(
//           recommendationDoc.data(),
//         );

//         final productSnapshot = await _firestore
//             .collection("Products")
//             .doc(recommendation.productId)
//             .get();

//         if (!productSnapshot.exists) continue;

//         final productData = productSnapshot.data()!;

//         products.add(
//           ProductModel.fromFirestore(
//             productSnapshot.id,
//             productData,
//             productData["imageUrl"] ?? "",
//           ),
//         );
//       }

//       return products;
//     } catch (e) {
//       print("Recommendation Error : $e");
//       return [];
//     }
//   }

//   /// Cooking specific recommendations
//   Future<List<ProductModel>> getRecommendationsForCooking({
//     required String productId,
//     required String cookingOptionId,
//   }) async {
//     try {
//       final recommendationSnapshot = await _firestore
//           .collection("Products")
//           .doc(productId)
//           .collection("CookingOptions")
//           .doc(cookingOptionId)
//           .collection("Recommendations")
//           .where("active", isEqualTo: true)
//           .orderBy("displayOrder")
//           .get();

//       List<ProductModel> products = [];

//       for (final recommendationDoc in recommendationSnapshot.docs) {
//         final recommendation = RecommendationModel.fromFirestore(
//           recommendationDoc.data(),
//         );

//         final productSnapshot = await _firestore
//             .collection("Products")
//             .doc(recommendation.productId)
//             .get();

//         if (!productSnapshot.exists) continue;

//         final productData = productSnapshot.data()!;

//         products.add(
//           ProductModel.fromFirestore(
//             productSnapshot.id,
//             productData,
//             productData["imageUrl"] ?? "",
//           ),
//         );
//       }

//       return products;
//     } catch (e) {
//       print("Cooking Recommendation Error : $e");
//       return [];
//     }
//   }
// }




// // class RecommendationService {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final FirebaseStorage _storage = FirebaseStorage.instance;

// //   Future<List<ProductModel>> getRecommendations(
// //       String productId,
// //       ) async {
// //     try {
// //       /// Step 1 : Read Recommendations
// //       final recommendationSnapshot = await _firestore
// //           .collection("Products")
// //           .doc(productId)
// //           .collection("Recommendations")
// //           .where("active", isEqualTo: true)
// //  //         .orderBy("displayOrder")
// //           .get();

// //       if (recommendationSnapshot.docs.isEmpty) {
// //         return [];
// //       }

// //       List<ProductModel> products = [];

// //       /// Step 2 : Loop recommendation list
// //       for (var recommendationDoc in recommendationSnapshot.docs) {
// // print("Recommendation Data:");
// //         final recommendation = RecommendationModel.fromFirestore(
// //           recommendationDoc.data(),
// //         );
// // print("Recommendation Parsed");
// //         /// Step 3 : Read Product
// //         final productDoc = await _firestore
// //             .collection("Products")
// //             .doc(recommendation.productId)
// //             .get();

// //         if (!productDoc.exists) {
// //           continue;
// //         }

// //         final productData = productDoc.data()!;
// //         print(productData);
// //         print("=================================");
// // print("Product : ${productDoc.id}");
// // print("Purchase Options : ${productData["purchaseOptions"]}");
// // print("Unit : ${productData["unit"]}");
// // print("=================================");
// //         /// Step 4 : Get Image URL
// //         String imageUrl = "";

// //         try {
// //           imageUrl = await _storage
// //               .ref(productData["imagePath"])
// //               .getDownloadURL();
// //         } catch (_) {}
// // print("Image URL Loaded");
// //         /// Step 5 : Convert to ProductModel
// //         products.add(
// //           ProductModel.fromFirestore(
// //             productDoc.id,
// //             productData,
// //             imageUrl,
// //           ),
// //         );
// //   print("ProductModel Created");

// //       }

// //       return products;
// //     } catch (e) {
// //       print("Recommendation Error : $e");
// //       return [];
// //     }
// //   }
// // }