import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.95);

  List<String> banners = [];

  bool loading = true;

  Timer? _timer;

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadBanners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadBanners() async {
    try {
      final result =
          await FirebaseStorage.instance.ref("Banner").listAll();

      List<String> temp = [];

      for (var item in result.items) {
        temp.add(await item.getDownloadURL());
      }

      if (!mounted) return;

      setState(() {
        banners = temp;
        loading = false;
      });

      if (banners.isNotEmpty) {
        startAutoScroll();
      }
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  void startAutoScroll() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_pageController.hasClients) return;

      currentPage++;

      if (currentPage >= banners.length) {
        currentPage = 0;
      }

      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: 180,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (banners.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(
          child: Text("No Banner Found"),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        onPageChanged: (index) {
          currentPage = index;
        },
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                banners[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}