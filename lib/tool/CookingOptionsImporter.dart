import 'package:cloud_firestore/cloud_firestore.dart';

class CookingOptionsImporter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, List<Map<String, dynamic>>> cookingOptions = {
    "Broiler Without Skin": [
      {
        "id": "biryani",
        "nameEn": "Biryani",
        "nameTa": "பிரியாணி",
        "icon": "🍛",
        "cutTypeEn": "Medium Biryani Pieces",
        "cutTypeTa": "பிரியாணிக்கான நடுத்தர துண்டுகள்",
        "cutCode": "MEDIUM_BIRYANI",
        "displayOrder": 1,
        "active": true,
      },
      {
        "id": "fry",
        "nameEn": "Fry",
        "nameTa": "வறுவல்",
        "icon": "🍗",
        "cutTypeEn": "Medium Pieces",
        "cutTypeTa": "நடுத்தர துண்டுகள்",
        "cutCode": "MEDIUM_PIECES",
        "displayOrder": 2,
        "active": true,
      },
      {
        "id": "bbq",
        "nameEn": "BBQ",
        "nameTa": "பார்பிக்யூ",
        "icon": "🔥",
        "cutTypeEn": "Large BBQ Pieces",
        "cutTypeTa": "பெரிய பார்பிக்யூ துண்டுகள்",
        "cutCode": "LARGE_BBQ",
        "displayOrder": 3,
        "active": true,
      },
      {
        "id": "chicken65",
        "nameEn": "Chicken 65",
        "nameTa": "சிக்கன் 65",
        "icon": "🌶️",
        "cutTypeEn": "Small Pieces",
        "cutTypeTa": "சிறிய துண்டுகள்",
        "cutCode": "SMALL_PIECES",
        "displayOrder": 4,
        "active": true,
      },
      {
        "id": "gravy",
        "nameEn": "Gravy",
        "nameTa": "குழம்பு",
        "icon": "🍲",
        "cutTypeEn": "Medium Curry Pieces",
        "cutTypeTa": "குழம்பிற்கான நடுத்தர துண்டுகள்",
        "cutCode": "MEDIUM_CURRY",
        "displayOrder": 5,
        "active": true,
      },
      {
        "id": "soup",
        "nameEn": "Soup",
        "nameTa": "சூப்",
        "icon": "🥣",
        "cutTypeEn": "Small Bone Pieces",
        "cutTypeTa": "சிறிய எலும்பு துண்டுகள்",
        "cutCode": "SMALL_BONE",
        "displayOrder": 6,
        "active": true,
      },
      {
        "id": "tandoori",
        "nameEn": "Tandoori",
        "nameTa": "தந்தூரி",
        "icon": "🍖",
        "cutTypeEn": "Full Leg Pieces",
        "cutTypeTa": "முழு கால் துண்டுகள்",
        "cutCode": "FULL_LEG",
        "displayOrder": 7,
        "active": true,
      },
    ],
  };

  Future<void> importCookingOptions() async {
    try {
      final batch = _firestore.batch();

      for (final product in cookingOptions.entries) {
        final productId = product.key;

        for (final option in product.value) {
          final docRef = _firestore
              .collection("Products")
              .doc(productId)
              .collection("CookingOptions")
              .doc(option["id"] as String);

          batch.set(docRef, option);

          print(
              "Uploading: $productId -> ${option["nameEn"]}");
        }
      }

      await batch.commit();

      print("====================================");
      print("Cooking Options Imported Successfully");
      print("====================================");
    } catch (e) {
      print("Error importing cooking options: $e");
    }
  }
}