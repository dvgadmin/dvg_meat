import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../services/cart_service.dart';
import '../widgets/quantity_selector.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({
    super.key,
  });

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final CartService _cartService = CartService();

  List<CartItemModel> get _items => _cartService.items;

  void _increaseQuantity(int index) {
    setState(() {
      _cartService.increaseQuantity(index);
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      _cartService.decreaseQuantity(index);
    });
  }

  void _removeItem(int index) {
    final item = _items[index];

    setState(() {
      _cartService.removeItem(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${item.product.nameEn} removed from basket",
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        title: const Text(
          "My Basket",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: _items.isEmpty
          ? _buildEmptyBasket()
          : Column(
              children: [

                // --------------------------------------------------
                // ITEM COUNT
                // --------------------------------------------------

                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    "${_cartService.itemCount} item${_cartService.itemCount == 1 ? '' : 's'} in your basket",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // --------------------------------------------------
                // CART ITEMS
                // --------------------------------------------------

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(
                        _items[index],
                        index,
                      );
                    },
                  ),
                ),

                // --------------------------------------------------
                // SUMMARY
                // --------------------------------------------------

                _buildBasketSummary(),
              ],
            ),
    );
  }

  // ================================================================
  // CART ITEM
  // ================================================================

  Widget _buildCartItem(
    CartItemModel item,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ------------------------------------------------------
            // IMAGE
            // ------------------------------------------------------

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: 85,
                height: 85,
                fit: BoxFit.cover,
                loadingBuilder:
                    (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Container(
                    width: 85,
                    height: 85,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    width: 85,
                    height: 85,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // ------------------------------------------------------
            // PRODUCT DETAILS
            // ------------------------------------------------------

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      Expanded(
                        child: Text(
                          item.product.nameEn,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          _removeItem(index);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        tooltip: "Remove",
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${item.weightLabel} × ${item.quantity}",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "₹${item.unitPrice.toStringAsFixed(2)} each",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      QuantitySelector(
                        quantity: item.quantity,
                        onAdd: () {
                          _increaseQuantity(index);
                        },
                        onRemove: () {
                          _decreaseQuantity(index);
                        },
                      ),

                      const Spacer(),

                      Text(
                        "₹${item.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // BASKET SUMMARY
  // ================================================================

  Widget _buildBasketSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [

          // --------------------------------------------------------
          // SUBTOTAL
          // --------------------------------------------------------

          Row(
            children: [

              const Text(
                "Subtotal",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),

              const Spacer(),

              Text(
                "₹${_cartService.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // --------------------------------------------------------
          // DELIVERY
          // --------------------------------------------------------

          const Row(
            children: [

              Text(
                "Delivery",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),

              Spacer(),

              Text(
                "FREE",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(),

          const SizedBox(height: 8),

          // --------------------------------------------------------
          // TOTAL
          // --------------------------------------------------------

          Row(
            children: [

              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Text(
                "₹${_cartService.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // --------------------------------------------------------
          // CHECKOUT BUTTON
          // --------------------------------------------------------

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                // Checkout will be implemented later.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Checkout will be available soon.",
                    ),
                  ),
                );
              },
              child: const Text(
                "Proceed to Checkout",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // EMPTY BASKET
  // ================================================================

  Widget _buildEmptyBasket() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Icon(
              Icons.shopping_basket_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              "Your basket is empty",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Add some delicious items to your basket.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Continue Shopping",
              ),
            ),
          ],
        ),
      ),
    );
  }
}