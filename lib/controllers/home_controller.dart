import 'dart:async';
import 'package:flutter/material.dart';
import '../models/banner_model.dart';

class HomeController extends ChangeNotifier {
  final List<BannerModel> banners = [
    const BannerModel(
      title: "THINKING IS THE CAPITAL,",
      subtitle: "ENTERPRISE IS THE WAY,\nHARD WORK IS THE SOLUTION.",
    ),
    const BannerModel(
      title: "EXCELLENCE IS A CONTINUOUS PROCESS",
      subtitle: "AND NOT AN ACCIDENT.",
    ),
    const BannerModel(
      title: "DREAM, DREAM, DREAM",
      // Use raw string to avoid \n warning
      subtitle: r"DREAMS TRANSFORM INTO THOUGHTS" ,
    ),
  ];

  late PageController pageController;
  int currentPage = 0;
  Timer? _timer;

  HomeController() {
    pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      currentPage = (currentPage + 1) % banners.length; // Cleaner loop
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    });
  }

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}