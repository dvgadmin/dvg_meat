class ProductModel {
  final String id;
  final String categoryId;
  final String category;

  final String nameEn;
  final String nameTa;

  final String descriptionEn;
  final String descriptionTa;

  final String imagePath;

  /// Download URL from Firebase Storage
  final String imageUrl;

  final double price;
  final String unit;

  final bool active;
  final bool stock;

  final bool isBestSeller;

  final double rating;
  final int ratingCount;

  final int displayOrder;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.category,

    required this.nameEn,
    required this.nameTa,

    required this.descriptionEn,
    required this.descriptionTa,

    required this.imagePath,
    required this.imageUrl,

    required this.price,
    required this.unit,

    required this.active,
    required this.stock,

    required this.isBestSeller,

    required this.rating,
    required this.ratingCount,

    required this.displayOrder,
  });

  factory ProductModel.fromFirestore(
    String id,
    Map<String, dynamic> json,
    String imageUrl,
  ) {
    return ProductModel(
      id: id,

      categoryId: json["categoryId"] ?? "",
      category: json["category"] ?? "",

      nameEn: json["name_en"] ?? "",
      nameTa: json["name_ta"] ?? "",

      descriptionEn: json["description_en"] ?? "",
      descriptionTa: json["description_ta"] ?? "",

      imagePath: json["imagePath"] ?? "",
      imageUrl: imageUrl,

      price: (json["price"] as num?)?.toDouble() ?? 0.0,

      unit: json["unit"] ?? "kg",

      active: json["active"] ?? true,
      stock: json["stock"] ?? true,

      isBestSeller: json["isBestSeller"] ?? false,

      rating: (json["rating"] as num?)?.toDouble() ?? 0.0,

      ratingCount: (json["ratingCount"] as num?)?.toInt() ?? 0,

      displayOrder: (json["displayOrder"] as num?)?.toInt() ?? 0,
    );
  }
}