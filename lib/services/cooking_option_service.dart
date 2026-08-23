import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cooking_option_model.dart';

class CookingOptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<CookingOptionModel>> getCookingOptions(String productId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Products')
      .doc(productId)
      .collection('CookingOptions')
      .get();

  final options = snapshot.docs
      .map((doc) => CookingOptionModel.fromFirestore(doc))
      .where((option) => option.active)
      .toList();

  options.sort(
    (a, b) => a.displayOrder.compareTo(b.displayOrder),
  );

  return options;
}
}