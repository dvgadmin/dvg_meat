import 'package:dvg_meat/models/product_model.dart';
import 'package:dvg_meat/widgets/quantity_selector.dart';
import 'package:dvg_meat/widgets/weight_selector.dart';
import 'package:flutter/material.dart';

class RecommendationProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback? onAddToCart;

  /// Controlled by CookingAssistantPopup
  final bool isExpanded;
  final VoidCallback onTap;

  const RecommendationProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<RecommendationProductCard> createState() =>
      _RecommendationProductCardState();
}

class _RecommendationProductCardState
    extends State<RecommendationProductCard> {
  late int _selectedWeight;

  int _quantity = 1;

  bool _added = false;

  @override
  void initState() {
    super.initState();

    _selectedWeight =
        widget.product.purchaseOptions.isNotEmpty
            ? widget.product.purchaseOptions.first
            : 1;
  }

  String _weightLabel(int value) {
    switch (widget.product.unit.toLowerCase()) {
      case "kg":
        if (value >= 1000) {
          return "${value ~/ 1000} Kg";
        }

        return "${value}g";

      case "nos":
        return "$value Nos";

      case "packet":
        return "$value Pack";

      default:
        return value.toString();
    }
  }

  double get _singlePrice {
    switch (widget.product.unit.toLowerCase()) {
      case "kg":
        return (widget.product.price * _selectedWeight) / 1000;

      default:
        return widget.product.price;
    }
  }

  double get _totalPrice {
    return _singlePrice * _quantity;
  }

  void _increaseQty() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQty() {
    if (_quantity <= 1) {
      return;
    }

    setState(() {
      _quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [

              // =========================================================
              // PRODUCT SUMMARY
              // Always visible
              // =========================================================

              Row(
                children: [

                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Container(
                          width: 70,
                          height: 70,
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
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Product information
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          widget.product.nameEn,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [

                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 17,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              widget.product.rating
                                  .toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(width: 8),

                            Text(
                              "(${widget.product.ratingCount})",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 5),

                        // Show base price when collapsed
                        if (!widget.isExpanded)
                          Text(
                            "₹${widget.product.price.toStringAsFixed(2)} / ${widget.product.unit}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Expand / collapse icon
                  Icon(
                    widget.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),

              // =========================================================
              // EXPANDED SECTION
              // =========================================================

              if (widget.isExpanded) ...[
                const SizedBox(height: 16),

                const Divider(),

                const SizedBox(height: 12),

                // Selected price
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "₹${_singlePrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Weight
                if (widget.product.purchaseOptions.isNotEmpty) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Weight",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: WeightSelector(
                      weights:
                          widget.product.purchaseOptions,
                      selectedWeight: _selectedWeight,
                      onChanged: (weight) {
                        setState(() {
                          _selectedWeight = weight;
                          _added = false;
                        });
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Quantity
                Row(
                  children: [

                    const Text(
                      "Quantity",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const Spacer(),

                    QuantitySelector(
                      quantity: _quantity,
                      onAdd: () {
                        _increaseQty();

                        setState(() {
                          _added = false;
                        });
                      },
                      onRemove: () {
                        _decreaseQty();

                        setState(() {
                          _added = false;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Total + Add button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Total",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),

                            Text(
                              "₹${_totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor: _added
                                ? Colors.green
                                : Colors.orange,
                            foregroundColor: Colors.white,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _added = true;
                            });

                            widget.onAddToCart?.call();
                          },
                          icon: Icon(
                            _added
                                ? Icons.check
                                : Icons.shopping_cart,
                            size: 18,
                          ),
                          label: Text(
                            _added ? "Added" : "Add",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}