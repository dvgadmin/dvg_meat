import 'package:flutter/material.dart';
import 'dart:async';
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
late final ScrollController _scrollController;
Timer? _autoScrollTimer;
  List<ProductModel> recommendations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
     _scrollController = ScrollController();
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
      _startAutoScroll();
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

void _startAutoScroll() {
  _autoScrollTimer?.cancel();

  if (recommendations.length <= 1) return;

  _autoScrollTimer = Timer.periodic(
    const Duration(seconds: 2),
    (_) async {
      if (!_scrollController.hasClients) return;

      const itemWidth = 102.0;

      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;

      if (current + itemWidth >= max) {
        // Move to the last position
        await _scrollController.animateTo(
          max,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        // Wait on the last item
        await Future.delayed(const Duration(seconds: 2));

        if (!_scrollController.hasClients) return;

        // Smoothly return to the first item
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      } else {
        await _scrollController.animateTo(
          current + itemWidth,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    },
  );
}

@override
void dispose() {
  _autoScrollTimer?.cancel();
  _scrollController.dispose();
  super.dispose();
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
              controller: _scrollController,
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