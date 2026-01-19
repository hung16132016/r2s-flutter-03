import 'package:flutter/material.dart';
import '../../task_manager_app/utils/app_colors.dart';
import '../../task_manager_app/utils/app_spacing.dart';
import '../../task_manager_app/utils/animations.dart';
import '../../task_manager_app/utils/path_management.dart';
import '../utils/app_spacing.dart';
import 'home_screen.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': PathManagement.logoPath,
      'title': 'Welcome to Task Manager!\nOrganize your work better.',
    },
    {
      'image': PathManagement.logoPath,
      'title': 'Create tasks and manage them\nwith ease.',
    },
    {
      'image': PathManagement.logoPath,
      'title': 'Get started now!\nLet\'s go!',
    },
  ];

  void _goToHome() {
    Navigator.of(context)
        .pushReplacement(Animations.createSlideTransition(const HomeScreen()));
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _goToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseBlack,
      body: PageView.builder(
        itemCount: _pages.length,
        controller: _controller,
        onPageChanged: (index) => setState(() {
          _currentPage = index;
        }),
        itemBuilder: (_, index) {
          return Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  _pages[index]['image']!,
                  height: 200,
                ),
                AppSpacing.gapMd,
                Text(
                  _pages[index]['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapLg,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                        (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == i
                            ? AppColors.purplePrimary
                            : AppColors.greyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        padding: AppSpacing.horizontalMd,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          border: Border(top: BorderSide(color: AppColors.greyDark)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: _goToHome,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purplePrimary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                    style: const TextStyle(fontSize: 16),
                  ),
                  AppSpacing.gapXs,
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}