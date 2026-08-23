import 'package:cloud_firestore/cloud_firestore.dart';

class CookingOptionModel {
  final String id;
  final String nameEn;
  final String nameTa;
  final String icon;
  final String cutTypeEn;
  final String cutTypeTa;
  final String cutCode;
  final int displayOrder;
  final bool active;

  const CookingOptionModel({
    required this.id,
    required this.nameEn,
    required this.nameTa,
    required this.icon,
    required this.cutTypeEn,
    required this.cutTypeTa,
    required this.cutCode,
    required this.displayOrder,
    required this.active,
  });

  factory CookingOptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CookingOptionModel(
      id: doc.id,
      nameEn: data['nameEn'] ?? '',
      nameTa: data['nameTa'] ?? '',
      icon: data['icon'] ?? '',
      cutTypeEn: data['cutTypeEn'] ?? '',
      cutTypeTa: data['cutTypeTa'] ?? '',
      cutCode: data['cutCode'] ?? '',
      displayOrder: data['displayOrder'] ?? 0,
      active: data['active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameEn': nameEn,
      'nameTa': nameTa,
      'icon': icon,
      'cutTypeEn': cutTypeEn,
      'cutTypeTa': cutTypeTa,
      'cutCode': cutCode,
      'displayOrder': displayOrder,
      'active': active,
    };
  }
}