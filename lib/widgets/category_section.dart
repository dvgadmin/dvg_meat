import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CategoryModel {
  final String name;
  final String image;

  CategoryModel({
    required this.name,
    required this.image,
  });
}

class CategorySection extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategorySection({
    super.key,
    required this.onCategorySelected,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  List<CategoryModel> categories = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    final result =
        await FirebaseStorage.instance.ref("Categories").listAll();

    List<CategoryModel> temp = [];

    for (Reference item in result.items) {
      String url = await item.getDownloadURL();

      temp.add(
        CategoryModel(
          name: item.name.split(".").first,
          image: url,
        ),
      );
    }

    setState(() {
      categories = temp;
    });

    /// Select first category automatically
    if (categories.isNotEmpty) {
      widget.onCategorySelected(categories.first.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox(
        height: 110,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });

              widget.onCategorySelected(category.name);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 15),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedIndex == index
                            ? Colors.green
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 34,
                      backgroundImage: NetworkImage(category.image),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: 75,
                    child: Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// class ProductCategory {
//   final String name;
//   final String imageUrl;

//   ProductCategory({
//     required this.name,
//     required this.imageUrl,
//   });
// }

// class CategorySection extends StatelessWidget {
//   const CategorySection({super.key});

//   Future<List<ProductCategory>> getCategories() async {
//     final result = await FirebaseStorage.instance
//         .ref('Product List')
//         .listAll();

//     List<ProductCategory> categories = [];

//     for (final item in result.items) {
//       final url = await item.getDownloadURL();

//       categories.add(
//         ProductCategory(
//           name: item.name.split('.').first,
//           imageUrl: url,
//         ),
//       );
//     }

//     return categories;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<ProductCategory>>(
//       future: getCategories(),
//       builder: (context, snapshot) {

//         if (!snapshot.hasData) {
//           return const SizedBox(
//             height: 100,
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }

//         final categories = snapshot.data!;

//         return SizedBox(
//           height: 100,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: categories.length,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemBuilder: (context, index) {

//               final category = categories[index];

//               return Padding(
//                 padding: const EdgeInsets.only(right: 12),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 32,
//                       backgroundImage:
//                           NetworkImage(category.imageUrl),
//                     ),
//                     const SizedBox(height: 6),
//                     SizedBox(
//                       width: 70,
//                       child: Text(
//                         category.name,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }