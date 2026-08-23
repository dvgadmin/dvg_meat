import 'package:dvg_meat/models/product_model.dart';
import 'package:dvg_meat/widgets/recommendation_header.dart';
import 'package:dvg_meat/widgets/recommendation_product_card.dart';
import 'package:flutter/material.dart';
import 'package:dvg_meat/models/cooking_option_model.dart';
import 'package:dvg_meat/services/cooking_option_service.dart';
import 'package:dvg_meat/services/recommendation_service.dart';

class CookingAssistantPopup extends StatefulWidget {
  final ProductModel product;

 const CookingAssistantPopup({
  super.key,
  required this.product,
});

@override
State<CookingAssistantPopup> createState() =>
    _CookingAssistantPopupState();
}

class _CookingAssistantPopupState
    extends State<CookingAssistantPopup> {
final CookingOptionService _service = CookingOptionService();
late Future<List<CookingOptionModel>> _futureCookingOptions;
bool _showRecommendations = false;
bool _loadingRecommendations = false;
int? _expandedRecommendationIndex;

final RecommendationService _recommendationService =
    RecommendationService();
List<ProductModel> _recommendations = [];

@override
void initState() {
  super.initState();

  _futureCookingOptions =
      _service.getCookingOptions(widget.product.id);
}

Future<void> _onCookingOptionSelected(
    CookingOptionModel option) async {

  try {

    print("========== OPTION CLICKED ==========");
    print(option.nameEn);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.product.nameEn} added to basket"),
        backgroundColor: Colors.green,
      ),
    );

    print("Loading recommendations...");

    final products =
        await _recommendationService.getRecommendationsForCooking(
      productId: widget.product.id,
      cookingOptionId: option.id,
    );

for (final p in products) {
  print("======================");
  print(p.nameEn);
  print("Image URL: ${p.imageUrl}");
}

    print("Recommendations loaded");
    print(products.length);

    setState(() {
      _recommendations = products;
      _showRecommendations = true;
    });

    print("UI Updated");

  } catch (e, stack) {
    print("ERROR OCCURRED");
    print(e);
    print(stack);
  }
}

Widget _option(CookingOptionModel option) {

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _onCookingOptionSelected(option),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [

            Text(
  option.icon,
  style: const TextStyle(fontSize: 24),
),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                option.nameEn,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),

            const Icon(Icons.arrow_forward_ios,size:16)

          ],
        ),
      ),
    ),
  );
}

// Widget _buildRecommendationScreen() {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       RecommendationHeader(
//   productName: widget.product.nameEn,
// ),
//       // const Text(
//       //   "🎉 Added to Basket",
//       //   style: TextStyle(
//       //     fontSize: 22,
//       //     fontWeight: FontWeight.bold,
//       //     color: Colors.green,
//       //   ),
//       // ),

//       // const SizedBox(height: 10),

//       // Text(
//       //   "${widget.product.nameEn} has been added.",
//       //   textAlign: TextAlign.center,
//       // ),

//       // const SizedBox(height: 25),

//       // const Text(
//       //   "Recommended for your recipe",
//       //   style: TextStyle(
//       //     fontSize: 20,
//       //     fontWeight: FontWeight.bold,
//       //   ),
//       // ),

//       // const SizedBox(height: 15),

// //       ..._recommendations.map((product) {
// //         return Card(
// //           margin: const EdgeInsets.only(bottom: 10),
// //           child: ListTile(
// //             leading: ClipRRect(
// //   borderRadius: BorderRadius.circular(8),
// //   child: Image.network(
// //     product.imageUrl,
// //     width: 60,
// //     height: 60,
// //     fit: BoxFit.cover,
// //     loadingBuilder: (context, child, loadingProgress) {
// //       if (loadingProgress == null) return child;

// //       return const SizedBox(
// //         width: 60,
// //         height: 60,
// //         child: Center(
// //           child: CircularProgressIndicator(strokeWidth: 2),
// //         ),
// //       );
// //     },
// //     errorBuilder: (context, error, stackTrace) {
// //       return Container(
// //         width: 60,
// //         height: 60,
// //         color: Colors.grey.shade200,
// //         child: const Icon(Icons.image_not_supported),
// //       );
// //     },
// //   ),
// // ),
// //             title: Text(product.nameEn),
// //             subtitle: Text("₹${product.price}"),
// //             trailing: ElevatedButton(
// //               onPressed: () {
// //                 // We'll implement this later
// //               },
// //               child: const Text("Add"),
// //             ),
// //           ),
// //         );
// //       })
// ..._recommendations.map((product) {
//   return RecommendationProductCard(
//     product: product,
//     onAddToCart: () {
//       // Cart integration later
//     },
//   );
// }).toList(),

//       const SizedBox(height: 20),

//       Row(
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Continue Shopping"),
//             ),
//           ),

//           const SizedBox(width: 10),

//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 // Basket screen later
//                 Navigator.pop(context);
//               },
//               child: const Text("View Basket"),
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }
Widget _buildRecommendationScreen() {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.95,
    height: MediaQuery.of(context).size.height * 0.85,
    child: Column(
      children: [
        // ==============================
        // HEADER - FIXED
        // ==============================
        RecommendationHeader(
          productName: widget.product.nameEn,
        ),

        const Divider(
          height: 1,
        ),

        // ==============================
        // RECOMMENDATIONS - SCROLLABLE
        // ==============================
        Expanded(
          child: _recommendations.isEmpty
              ? const Center(
                  child: Text(
                    "No recommendations available.",
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _recommendations.length,
                  itemBuilder: (context, index) {
                    final product = _recommendations[index];

                    // return RecommendationProductCard(
                    //   product: product,
                    //   onAddToCart: () {
                    //     // Cart integration later
                    //   },
                    // );
                    return RecommendationProductCard(
                            product: product,
                            isExpanded: _expandedRecommendationIndex == index,
                            onTap: () {
                              setState(() {
                                if (_expandedRecommendationIndex == index) {
                                  _expandedRecommendationIndex = null;
                                } else {
                                  _expandedRecommendationIndex = index;
                                }
                              });
                            },
                            onAddToCart: () {
                              // Cart integration later
                            },
                          );
                  },
                ),
        ),

        // ==============================
        // BOTTOM BUTTONS - FIXED
        // ==============================
        const Divider(
          height: 1,
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Continue Shopping",
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Basket screen later
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "View Basket",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
  return Material(
    color: Colors.black54,
    child: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * .90,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: _showRecommendations
    ? _buildRecommendationScreen()
    : Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "🍗 How are you cooking today?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Select your cooking style",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

FutureBuilder<List<CookingOptionModel>>(
  future: _futureCookingOptions,
  builder: (context, snapshot) {

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (snapshot.hasError) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "Error : ${snapshot.error}",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final options = snapshot.data ?? [];

    if (options.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No cooking options available.",
        ),
      );
    }

    return Column(
      children: options
          .map((option) => _option(option))
          .toList(),
    );
  },
),

          ],
        ),
      ),
    ),
  );
}
  
}

Future<void> showCookingAssistantPopup(
  BuildContext context,
  ProductModel product,
) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 250),

    pageBuilder: (context, animation, secondaryAnimation) {
      return CookingAssistantPopup(product: product);
    },

    transitionBuilder: (
      context,
      animation,
      secondaryAnimation,
      child,
    ) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.90,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
          ),
          child: child,
        ),
      );
    },
  );
}
