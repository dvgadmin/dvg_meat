import 'package:dvg_meat/screens/home_page.dart';
import 'package:dvg_meat/tool/CookingOptionsImporter.dart';
import 'package:dvg_meat/tool/RecommendationImporter.dart';
import 'package:dvg_meat/tool/firestore_import.dart';
import 'package:dvg_meat/tool/firestore_import_recommendation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
print("Project ID: ${Firebase.app().options.projectId}");
print("App ID: ${Firebase.app().options.appId}");
print("API Key: ${Firebase.app().options.apiKey}");
print("Storage Bucket: ${Firebase.app().options.storageBucket}");

// Run only once when you want to import
//  await FirestoreImporter().importProducts();
//  await FirestoreImporterRecommendation().importProducts();
//  await CookingOptionsImporter().importCookingOptions(); // Replace with the actual product ID you want to import cooking options for
//    await RecommendationImporter().importRecommendations(); // Import recommendations for all products
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}