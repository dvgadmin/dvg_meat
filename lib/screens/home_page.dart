import 'package:flutter/material.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_section.dart';
import '../widgets/product_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "Broiler";

  /// en / ta
  String selectedLanguage = "en";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// Search + Language
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [

                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: selectedLanguage == "en"
                              ? "Search"
                              : "தேடுக",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    ToggleButtons(
                      borderRadius: BorderRadius.circular(10),
                      isSelected: [
                        selectedLanguage == "en",
                        selectedLanguage == "ta",
                      ],
                      onPressed: (index) {
                        setState(() {
                          selectedLanguage =
                              index == 0 ? "en" : "ta";
                        });
                      },
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text("EN"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text("தமிழ்"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const BannerSlider(),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      selectedLanguage == "en"
                          ? "Product List"
                          : "பொருட்கள்",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              CategorySection(
//                language: selectedLanguage,
                onCategorySelected: (category) {
                  print("Selected Category = $category");
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),

              const SizedBox(height: 20),

              ProductGrid(
                folderName: selectedCategory,
                language: selectedLanguage,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import '../widgets/category_section.dart';
// import '../widgets/product_grid.dart';
// import '../widgets/banner_slider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

//   /// Default folder
//   String selectedCategory = "Broiler";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.explore), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
//         ],
//       ),

//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [

//               /// Search Bar
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search",
//                     prefixIcon: const Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 15),

//               /// Banner
//                const BannerSlider(),

//               const SizedBox(height: 20),

//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Product List",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     Spacer(),
//                     Icon(Icons.arrow_forward_ios, size: 16),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 15),

//               /// Categories from Firebase
//               CategorySection(
//                 onCategorySelected: (category) {
//                   setState(() {
//                     selectedCategory = category;
//                   });
//                 },
//               ),

//               const SizedBox(height: 20),

//               /// Dynamic products
//               ProductGrid(
//                 folderName: selectedCategory,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }