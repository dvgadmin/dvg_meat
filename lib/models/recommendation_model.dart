import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationModel {
  final String productId;
  final int displayOrder;
  final bool active;

  RecommendationModel({
    required this.productId,
    required this.displayOrder,
    required this.active,
  });


  factory RecommendationModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return RecommendationModel(
      productId: doc.id,
      displayOrder: data['displayOrder'] ?? 0,
      active: data['active'] ?? true,
    );
  }
}