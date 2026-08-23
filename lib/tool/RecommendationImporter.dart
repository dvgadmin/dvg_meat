import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationImporter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, Map<String, List<String>>> recommendations = {
    "Broiler Without Skin": {
      "biryani": [
        "Small Onion",
        "Tomato",
        "Ginger",
        "Garlic",
        "Green Chilli",
        "Fresh Herbs Combo",
        "Curd",
        "Lemon",
        "Biryani Masala",
      ],

      "fry": [
        "Onion",
        "Garlic",
        "Ginger",
        "Green Chilli",
        "Lemon",
        "Chicken Masala",
      ],

      "gravy": [
        "Onion",
        "Tomato",
        "Garlic",
        "Ginger",
        "Fresh Herbs Combo",
        "Coconut",
        "Curry Masala",
      ],

      "soup": [
        "Pepper",
        "Garlic",
        "Ginger",
        "Fresh Herbs Combo",
      ],

      "bbq": [
        "BBQ Marinade",
        "Butter",
        "Lemon",
      ],

      "tandoori": [
        "Curd",
        "Tandoori Masala",
        "Butter",
        "Lemon",
      ],

      "chicken65": [
        "Corn Flour",
        "Ginger Garlic Paste",
        "Curry Leaves",
        "Green Chilli",
        "Lemon",
      ],
    },

    "Broiler With Skin": {
      "bbq": [
        "BBQ Marinade",
        "Butter",
        "Lemon",
      ],

      "tandoori": [
        "Curd",
        "Tandoori Masala",
        "Butter",
        "Lemon",
      ],

      "grill": [
        "BBQ Marinade",
        "Butter",
        "Lemon",
        "Fresh Herbs Combo",
      ],
    },

    "Chicken Boneless": {
      "biryani": [
        "Small Onion",
        "Tomato",
        "Ginger",
        "Garlic",
        "Green Chilli",
        "Fresh Herbs Combo",
        "Curd",
        "Lemon",
        "Biryani Masala",
      ],

      "chicken65": [
        "Corn Flour",
        "Ginger Garlic Paste",
        "Curry Leaves",
        "Green Chilli",
        "Lemon",
      ],

      "fry": [
        "Onion",
        "Garlic",
        "Ginger",
        "Green Chilli",
        "Chicken Masala",
      ],
    },

    "Chicken Wings": {
      "bbq": [
        "BBQ Marinade",
        "Butter",
        "Lemon",
      ],

      "fry": [
        "Chicken Masala",
        "Ginger Garlic Paste",
        "Lemon",
      ],

      "tandoori": [
        "Curd",
        "Tandoori Masala",
        "Butter",
        "Lemon",
      ],
    },
  };

  Future<void> importRecommendations() async {
    try {
      final batch = _firestore.batch();

      for (final product in recommendations.entries) {
        final productId = product.key;

        for (final cookingOption in product.value.entries) {
          final cookingOptionId = cookingOption.key;

          for (int i = 0; i < cookingOption.value.length; i++) {
            final recommendationProductId = cookingOption.value[i];

            final docRef = _firestore
                .collection("Products")
                .doc(productId)
                .collection("CookingOptions")
                .doc(cookingOptionId)
                .collection("Recommendations")
                .doc(recommendationProductId);

            batch.set(docRef, {
              "displayOrder": i + 1,
              "active": true,
            });

            print(
              "✓ Uploaded: $productId -> $cookingOptionId -> $recommendationProductId",
            );
          }
        }
      }

      await batch.commit();

      print("==========================================");
      print("Recommendations Imported Successfully");
      print("==========================================");
    } catch (e) {
      print("Recommendation Import Error: $e");
    }
  }
}