//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../screens/product_details_page.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class ProductGrid extends StatefulWidget {
  final String folderName;
  final String language;

  const ProductGrid({
    super.key,
    required this.folderName,
    required this.language,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
//  List<Map<String, dynamic>> products = [];
List<ProductModel> products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  void didUpdateWidget(ProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.folderName != widget.folderName) {
      loadProducts();
    }
  }

 Future<void> loadProducts() async {
  setState(() {
    loading = true;
  });

  products = await FirestoreService.getProducts(
    widget.folderName,
  );

  setState(() {
    loading = false;
  });
} 

//   Future<void> loadProducts() async {
//     setState(() {
//       loading = true;
//     });

//     try {
//       print("Selected Category : ${widget.folderName}");
// print("Folder Name      : ${widget.folderName}");
// print("Searching For    : ${widget.folderName.toLowerCase()}");
//       final snapshot = await FirebaseFirestore.instance
//     .collection("Products")
//     .where("categoryId", isEqualTo: widget.folderName.toLowerCase())
//     .where("active", isEqualTo: true)
//     .orderBy("displayOrder")
//     .get();
// print("Documents Found : ${snapshot.docs.length}");
//       List<Map<String, dynamic>> temp = [];
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
// print("Image Path = ${data["imagePath"]}");
//         final imageUrl = await FirebaseStorage.instance
//             .ref(data["imagePath"])
//             .getDownloadURL();

//         temp.add({
//           "name_en": data["name_en"],
//           "name_ta": data["name_ta"],
//           "description_en": data["description_en"],
//           "description_ta": data["description_ta"],
//           "price": (data["price"] as num).toDouble(),
//           "unit": data["unit"],
//           "imageUrl": imageUrl,
//           "isBestSeller": data["isBestSeller"] ?? false,
//           "rating": (data["rating"] ?? 4.5).toDouble(),
//           "ratingCount": data["ratingCount"] ?? 0,
//           "stock": data["stock"] ?? true,
//         });
//       }

//       setState(() {
//         products = temp;
//         loading = false;
//       });
//     } catch (e) {
//       print(e);

//       setState(() {
//         loading = false;
//         products = [];
//       });
//     }
//   }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Text(
          "No Products Found",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.60,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        // return Card(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(15),
        //   ),
        //   elevation: 3,
return InkWell(
  borderRadius: BorderRadius.circular(15),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(
          product: product,
          language: widget.language,
        ),
      ),
    );
  },
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Expanded(
              //   child: ClipRRect(
              //     borderRadius: const BorderRadius.vertical(
              //       top: Radius.circular(15),
              //     ),
              //     child: Image.network(
              //       product["imageUrl"],
              //       width: double.infinity,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
SizedBox(
  height: 130,
   child: Stack(
  children: [

    /// Product Image
    ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(16),
      ),
      child: product.imageUrl.isNotEmpty
          ? Image.network(
              product.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,

              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) return child;

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 45,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            )
          : Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 45,
                  color: Colors.grey,
                ),
              ),
            ),
    ),

    /// Favourite Button
    Positioned(
      top: 10,
      right: 10,
      child: InkWell(
        onTap: () {
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (_) => ProductDetailsPage(
  //       product: product,
  //       language: widget.language,
  //     ),
  //   ),
  // );
},
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite_border_rounded,
            color: Colors.red,
            size: 22,
          ),
        ),
      ),
    ),
  ],
)
   //Stack(
//     children: [

//       /// Product Image
//       ClipRRect(
//         borderRadius: const BorderRadius.vertical(
//           top: Radius.circular(16),
//         ),
//         child: Image.network(
//           //product["imageUrl"],
//           product.imageUrl,
//           width: double.infinity,
//           height: double.infinity,
//           fit: BoxFit.cover,

//           loadingBuilder: (
//             context,
//             child,
//             loadingProgress,
//           ) {
//             if (loadingProgress == null) return child;

//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },

//           errorBuilder: (
//             context,
//             error,
//             stackTrace,
//           ) {
//             return Container(
//               color: Colors.grey.shade200,
//               child: const Center(
//                 child: Icon(
//                   Icons.image_not_supported,
//                   size: 45,
//                   color: Colors.grey,
//                 ),
//               ),
//             );
//           },
//         ),
//       ),

//       /// Bestseller Badge
//       // if (product["isBestSeller"] == true)
//       //   Positioned(
//       //     top: 10,
//       //     left: 10,
//       //     child: Container(
//       //       padding: const EdgeInsets.symmetric(
//       //         horizontal: 10,
//       //         vertical: 5,
//       //       ),
//       //       decoration: BoxDecoration(
//       //         color: Colors.orange,
//       //         borderRadius: BorderRadius.circular(20),
//       //       ),
//       //       child: const Row(
//       //         children: [

//       //           Icon(
//       //             Icons.star,
//       //             color: Colors.white,
//       //             size: 14,
//       //           ),

//       //           SizedBox(width: 4),

//       //           Text(
//       //             "🔥 Best Seller",
//       //             style: TextStyle(
//       //               color: Colors.white,
//       //               fontWeight: FontWeight.bold,
//       //               fontSize: 10,
//       //             ),
//       //           ),
//       //         ],
//       //       ),
//       //     ),
//       //   ),

//       /// Favourite Button
//       Positioned(
//         top: 10,
//         right: 10,
//         child: Positioned(
//   top: 10,
//   right: 10,
//   child: InkWell(
//     onTap: () {
//       // TODO: Add to Wishlist
//     },
//     borderRadius: BorderRadius.circular(30),
//     child: Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: const Icon(
//         Icons.favorite_border_rounded,
//         color: Colors.red,
//         size: 22,
//       ),
//     ),
//   ),
// ),
//       ),
//     ],
//   ),
),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.language == "ta"
                      ? product.nameTa//product["name_ta"]
                      : product.nameEn,//product["name_en"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.language == "ta"
                      ? product.descriptionTa//product["description_ta"]
                      : product.descriptionEn,//product["description_en"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "₹${product.price}/${product.unit}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
         ),
        );
      },
    );
  }
}




// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class ProductModel {
//   final String name;
//   final String imageUrl;

//   ProductModel({
//     required this.name,
//     required this.imageUrl,
//   });
// }

// class ProductGrid extends StatefulWidget {
//   final String folderName;

//   const ProductGrid({
//     super.key,
//     required this.folderName,
//   });

//   @override
//   State<ProductGrid> createState() => _ProductGridState();
// }

// class _ProductGridState extends State<ProductGrid> {
//   List<ProductModel> products = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadProducts();
//   }

//   @override
//   void didUpdateWidget(covariant ProductGrid oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (oldWidget.folderName != widget.folderName) {
//       loadProducts();
//     }
//   }

// Future<void> loadProducts() async {
//   setState(() {
//     isLoading = true;
//     products = [];
//   });

//   try {
//     debugPrint("====================================");
//     debugPrint("Selected Folder: '${widget.folderName}'");

//     final storageRef = FirebaseStorage.instance.ref(widget.folderName);

//     final result = await storageRef.listAll();

//     debugPrint("Files Found: ${result.items.length}");

//     List<ProductModel> temp = [];

//     for (Reference item in result.items) {
//       debugPrint("File: ${item.fullPath}");

//       final url = await item.getDownloadURL();

//       temp.add(
//         ProductModel(
//           name: item.name.split(".").first,
//           imageUrl: url,
//         ),
//       );
//     }

//     setState(() {
//       products = temp;
//       isLoading = false;
//     });
//   } catch (e) {
//     debugPrint("ERROR: $e");

//     setState(() {
//       products = [];
//       isLoading = false;
//     });
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const SizedBox(
//         height: 300,
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (products.isEmpty) {
//       return const SizedBox(
//         height: 250,
//         child: Center(
//           child: Text(
//             "No Products Found",
//             style: TextStyle(fontSize: 18),
//           ),
//         ),
//       );
//     }

//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       padding: const EdgeInsets.symmetric(horizontal: 16),

//       itemCount: products.length,

//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.72,
//       ),

//       itemBuilder: (context, index) {
//         final product = products[index];

//         return Card(
//           elevation: 3,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(12),
//                   ),
//                   child: Image.network(
//                     product.imageUrl,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: Text(
//                   product.name,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),

//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   "Brand",
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),

//               const Padding(
//                 padding: EdgeInsets.fromLTRB(8, 4, 8, 10),
//                 child: Text(
//                   "₹250",
//                   style: TextStyle(
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }