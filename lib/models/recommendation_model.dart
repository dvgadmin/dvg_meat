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
    Map<String, dynamic> json,
  ) {
    return RecommendationModel(
      productId: json["productId"] ?? "",
      displayOrder: (json["displayOrder"] as num?)?.toInt() ?? 0,
      active: json["active"] ?? true,
    );
  }
}