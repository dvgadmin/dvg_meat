import 'package:dvg_meat/models/product_model.dart';

class CartItemModel {
  final ProductModel product;

  /// Product image URL used by the Basket UI
  final String imageUrl;

  /// Selected purchase option
  /// Example: 250, 500, 1000
  final int selectedWeight;

  /// Number of units selected
  final int quantity;

  CartItemModel({
    required this.product,
    required this.imageUrl,
    required this.selectedWeight,
    required this.quantity,
  });

  /// Price for ONE selected quantity
  double get unitPrice {
    if (product.unit.toLowerCase() == "kg") {
      return (product.price * selectedWeight) / 1000;
    }

    return product.price;
  }

  /// Total price for this cart item
  double get totalPrice {
    return unitPrice * quantity;
  }

  /// Display selected weight
  String get weightLabel {
    switch (product.unit.toLowerCase()) {
      case "kg":
        if (selectedWeight >= 1000) {
          return "${selectedWeight ~/ 1000} Kg";
        }

        return "${selectedWeight}g";

      case "nos":
        return "$selectedWeight Nos";

      case "packet":
        return "$selectedWeight Pack";

      default:
        return selectedWeight.toString();
    }
  }

  /// Create a copy with updated values
  CartItemModel copyWith({
    String? imageUrl,
    int? selectedWeight,
    int? quantity,
  }) {
    return CartItemModel(
      product: product,
      imageUrl: imageUrl ?? this.imageUrl,
      selectedWeight:
          selectedWeight ?? this.selectedWeight,
      quantity:
          quantity ?? this.quantity,
    );
  }
}