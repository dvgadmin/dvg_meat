import 'package:dvg_meat/widgets/cooking_assistant_popup.dart';
import 'package:dvg_meat/widgets/recommendation_section.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/recommendation_service.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  final String language;


  const ProductDetailsPage({
    super.key,
    required this.product,
    required this.language,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;
  String selectedWeight = "1 Kg";
  late String selectedLanguage;
    // final RecommendationService _recommendationService =
    // RecommendationService();
    List<ProductModel> recommendations = [];
    late ProductModel currentProduct;

  @override
void initState() {
  super.initState();

  selectedLanguage = widget.language;
  currentProduct = widget.product;
}

void onRecommendationSelected(ProductModel product) {
   print("=================================");
  print("Selected Product : ${product.nameEn}");
  print("ID : ${product.id}");
  print("Unit : ${product.unit}");
  print("Purchase Options : ${product.purchaseOptions}");
  print("=================================");

  setState(() {
    currentProduct = product;
    quantity = 1;
    selectedWeight = "";
  });
}

// Future<void> loadRecommendations() async {

//   recommendations = await _recommendationService
//       .getRecommendations(currentProduct.id);

// }

Future<void> _testRecommendations() async {
  final service = RecommendationService();

  final products = await service.getRecommendationsForCooking(
    productId: "Broiler Without Skin", // Change if needed
    cookingOptionId: "biryani",        // Change if needed
  );

  print("==================================");
  print("Recommendations Found: ${products.length}");
  print("==================================");

  for (final product in products) {
    print(product.nameEn);
  }
}

String getDeliveryDate() {
  final now = DateTime.now();

  // Saturday after 6 PM
  if (now.weekday == DateTime.saturday && now.hour >= 18) {
    final nextSunday = now.add(const Duration(days: 8));
    return "${nextSunday.day}/${nextSunday.month}/${nextSunday.year}";
  }

  // Sunday
  if (now.weekday == DateTime.sunday) {
    return "${now.day}/${now.month}/${now.year}";
  }

  // Days until Sunday
  final daysUntilSunday = DateTime.sunday - now.weekday;
  final sunday = now.add(Duration(days: daysUntilSunday));

  return "${sunday.day}/${sunday.month}/${sunday.year}";
}

  @override
  Widget build(BuildContext context) {
    final product = currentProduct;
    print("BUILD -> ${product.nameEn}");
    print("BUILD Purchase Options -> ${product.purchaseOptions}");
    final displayWeights = product.purchaseOptions.map((option) {
  if (product.unit == "g") {
    return "${option}g";
  }

  if (option >= 1000) {
    return "${option ~/ 1000} Kg";
  }

  return "${option}g";
}).toList();
      print("Current Product : ${product.nameEn}");
      print("Purchase Options : ${product.purchaseOptions}");
      print("Display Weights : $displayWeights");
if (displayWeights.isNotEmpty) {
  if (!displayWeights.contains(selectedWeight)) {
    selectedWeight = displayWeights.first;
  }
} else {
  selectedWeight = "";
}
//     final displayWeights =
//     product.unit.toLowerCase() == "g"
//         ? gweights
//         : weights;
// double selectedMultiplier = 1.0;

// switch (selectedWeight) {
//     case "100g":
//     selectedMultiplier = 0.10;
//     break;

//   case "200g":
//     selectedMultiplier = 0.20;
//     break;

//   case "250g":
//     selectedMultiplier = 0.25;
//     break;

//   case "500g":
//     selectedMultiplier = 0.5;
//     break;

//   case "1 Kg":
//     selectedMultiplier = 1.0;
//     break;

//   case "2 Kg":
//     selectedMultiplier = 2.0;
//     break;
// }
double selectedMultiplier;

if (selectedWeight.contains("Kg")) {
  selectedMultiplier = double.parse(
    selectedWeight.replaceAll("Kg", "").trim(),
  );
} else {
  selectedMultiplier =
      double.parse(
        selectedWeight.replaceAll("g", "").trim(),
      ) /
      1000;
}
final double totalWeight = selectedMultiplier * quantity;
final double totalPrice = product.price * totalWeight;

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black12,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await showCookingAssistantPopup(
                        context,
                        currentProduct,
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text("Add to Cart"),
                  ),
                ),
              // Expanded(
              //   child: OutlinedButton.icon(
              //     onPressed: () {},
              //     icon: const Icon(Icons.shopping_cart_outlined),
              //     label: const Text("Add to Cart"),
              //     style: OutlinedButton.styleFrom(
              //       foregroundColor: Colors.green,
              //       side: const BorderSide(color: Colors.green),
              //       minimumSize: const Size(double.infinity, 55),
              //     ),
              //   ),
              // ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  child: const Text(
                    "Buy Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,

            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: product.id,
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 70,
                          ),
                        ),
                      ),
              ),
            ),

            actions: [

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(18),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    selectedLanguage == "ta"
                        ? product.nameTa
                        : product.nameEn,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [

                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 22,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        product.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        "(${product.ratingCount} Reviews)",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "₹${product.price.toStringAsFixed(0)}/${product.unit}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      Icon(
                        Icons.circle,
                        size: 12,
                        color:
                            product.stock ? Colors.green : Colors.red,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        product.stock
                            ? "In Stock"
                            : "Out of Stock",
                        style: TextStyle(
                          color: product.stock
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 35),

                  const Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    selectedLanguage == "ta"
                        ? product.descriptionTa
                        : product.descriptionEn,
                    style: TextStyle(
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // const Text(
                  //   "Select Weight",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 18,
                  //   ),
                  // ),

                  // const SizedBox(height: 15),

                  // Wrap(
                  //   spacing: 10,
                  //   children: weights.map((weight) {
                  //     final selected =
                  //         selectedWeight == weight;

                  //     return ChoiceChip(
                  //       label: Text(weight),
                  //       selected: selected,
                  //       onSelected: (_) {
                  //         setState(() {
                  //           selectedWeight = weight;
                  //         });
                  //       },
                  //     );
                  //   }).toList(),
                  // ),

                  // const SizedBox(height: 30),
if (product.unit == "kg" || product.unit == "g")...[
  const Text(
    "Select Weight",
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  ),

  const SizedBox(height: 15),


Wrap(
  spacing: 10,
  children: displayWeights.map((weight) {
      final selected = selectedWeight == weight;

      return ChoiceChip(
        label: Text(weight),
        selected: selected,
        onSelected: (_) {
          setState(() {
            selectedWeight = weight;
          });
        },
      );
    }).toList(),
  ),

  const SizedBox(height: 25),
],
                  const Text(
                    "Quantity",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        IconButton(
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          icon: const Icon(Icons.remove),
                        ),

                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
const SizedBox(height: 25),

Card(
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Order Summary",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const Text("Selected Weight"),
        //     Text(selectedWeight),
        //   ],
        // ),
if (product.unit.toLowerCase() == "kg")
  Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Selected Weight",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          selectedWeight,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Quantity"),
            Text(quantity.toString()),
          ],
        ),

        // const Divider(height: 25),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const Text(
        //       "Total Weight",
        //       style: TextStyle(fontWeight: FontWeight.bold),
        //     ),
        //     Text("${totalWeight.toStringAsFixed(2)} Kg"),
        //   ],
        // ),
if (product.unit.toLowerCase() == "kg") ...[
  const Divider(height: 25),

  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        "Total Weight",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        product.unit == "g"
    ? "${(totalWeight * 1000).toInt()} g"
    : "${totalWeight.toStringAsFixed(2)} Kg",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
],
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total Amount",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              "₹${totalPrice.toStringAsFixed(0)}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
),
                  // const SizedBox(height: 30),

                  // Card(
                  //   elevation: 0,
                  //   color: Colors.green.shade50,
                  //   child: ListTile(
                  //     leading: const Icon(
                  //       Icons.delivery_dining,
                  //       color: Colors.green,
                  //     ),
                  //     title: const Text("Delivery"),
                  //     subtitle: const Text(
                  //       "Delivered in 30-45 mins",
                  //     ),
                  //   ),
                  // ),

                  Card(
  elevation: 1,
  child: ListTile(
    leading: const Icon(
      Icons.local_shipping,
      color: Colors.green,
    ),
    title: const Text(
      "Next Delivery",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      "Sunday (${getDeliveryDate()})\nOrder before Saturday 6:00 PM",
    ),
  ),
),

                  const SizedBox(height: 25),

                  const Text(
                    "Why choose DVG Meat?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green),
                      SizedBox(width: 8),
                      Text("Farm Fresh"),
                    ],
                  ),

                  SizedBox(height: 10),

                  const Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green),
                      SizedBox(width: 8),
                      Text("Hygienically Packed"),
                    ],
                  ),

                  SizedBox(height: 10),

                  const Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green),
                      SizedBox(width: 8),
                      Text("Premium Quality"),
                    ],
                  ),

                  SizedBox(height: 10),

                  const Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green),
                      SizedBox(width: 8),
                      Text("Fresh Everyday"),
                    ],
                  ),

                  // RecommendationSection(
                  //   productId: currentProduct.id,
                  //   onProductSelected: onRecommendationSelected,
                  // ),
                  // const SizedBox(height: 100),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}