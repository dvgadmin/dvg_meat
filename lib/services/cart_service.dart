import 'package:dvg_meat/models/cart_item_model.dart';
import 'package:dvg_meat/models/product_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);

  /// Add a product to cart
  void addItem({
    required ProductModel product,
    required String imageUrl,
    required int selectedWeight,
    required int quantity,
  }) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedWeight == selectedWeight,
    );

    if (existingIndex >= 0) {
      final existingItem = _items[existingIndex];

      _items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      _items.add(
        CartItemModel(
          product: product,
          imageUrl: imageUrl,
          selectedWeight: selectedWeight,
          quantity: quantity,
        ),
      );
    }
  }

  /// Increase quantity
  void increaseQuantity(int index) {
    if (index < 0 || index >= _items.length) {
      return;
    }

    final item = _items[index];

    _items[index] = item.copyWith(
      quantity: item.quantity + 1,
    );
  }

  /// Decrease quantity
  void decreaseQuantity(int index) {
    if (index < 0 || index >= _items.length) {
      return;
    }

    final item = _items[index];

    if (item.quantity <= 1) {
      return;
    }

    _items[index] = item.copyWith(
      quantity: item.quantity - 1,
    );
  }

  /// Remove item completely
  void removeItem(int index) {
    if (index < 0 || index >= _items.length) {
      return;
    }

    _items.removeAt(index);
  }

  /// Clear entire basket
  void clearCart() {
    _items.clear();
  }

  /// Total number of items
  int get itemCount {
    return _items.fold(
      0,
      (total, item) => total + item.quantity,
    );
  }

  /// Total basket amount
  double get totalAmount {
    return _items.fold(
      0,
      (total, item) => total + item.totalPrice,
    );
  }

  /// Check whether basket is empty
  bool get isEmpty {
    return _items.isEmpty;
  }
}