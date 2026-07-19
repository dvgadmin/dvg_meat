import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../../services/recommendation_service.dart';

class RecommendationSection extends StatefulWidget {
  final String productId;
  final Function(ProductModel) onProductSelected;

  const RecommendationSection({
    super.key,
    required this.productId,
    required this.onProductSelected,
  });

  @override
  State<RecommendationSection> createState() =>
      _RecommendationSectionState();

}

class _RecommendationSectionState
    extends State<RecommendationSection> {
  final RecommendationService _service =
      RecommendationService();

  List<ProductModel> recommendations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecommendations();
  }

@override
void didUpdateWidget(covariant RecommendationSection oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.productId != widget.productId) {
    print("Product changed...");
    print("Old : ${oldWidget.productId}");
    print("New : ${widget.productId}");

    setState(() {
      isLoading = true;
      recommendations.clear();
    });

    loadRecommendations();
  }
}

  Future<void> loadRecommendations() async {
  try {
    print("==================================");
    print("Loading Recommendations...");
    print("Product Id : ${widget.productId}");

    final data =
        await _service.getRecommendations(widget.productId);

    print("Recommendation Count : ${data.length}");

    for (var item in data) {
      print(item.nameEn);
    }

    if (mounted) {
      setState(() {
        recommendations = data;
        isLoading = false;
      });
    }
  } catch (e) {
    print("Recommendation Error : $e");

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (recommendations.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Frequently Bought Together",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 12),
              itemBuilder: (context, index) {

                final product = recommendations[index];

                return GestureDetector(
                  onTap: () {
                    widget.onProductSelected(product);
                  },
                  child:  ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                      ),
                    ),
                  ),
                ),
              );
              },
            ),
          ),
        ],
      ),
    );
  }
}