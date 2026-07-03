import 'package:flutter/material.dart';
import '../../../core/utils/responsive_extensions.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/app_constants.dart';
import 'build_elevated_button.dart';
import 'navigation_builder.dart';
import 'pageview_builder.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = "Onboarding";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _imageController;
  late PageController _textController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _imageController = PageController();
    _textController = PageController();
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageviewBuilder(
                pageController: _imageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  _textController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: AppColors.babyBlue,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: context.width(0.15),
                  vertical: context.height(0.02),
                ),
                child: Column(
                  children: [
                    SizedBox(height: context.height(0.01)),
                    NavigationBuilder(currentIndex: _currentIndex),
                    SizedBox(height: context.height(0.02)),
                    Expanded(
                      child: PageView.builder(
                        controller: _textController,
                        itemCount: AppConstants.pages.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Center(
                            child: Text(
                              AppConstants.pages[index]['desc']!,
                              textAlign: TextAlign.center,
                              style: AppStyles.blue50regular.copyWith(
                                fontSize: context.sp(32),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    BuildElevatedButton(
                      currentIndex: _currentIndex,
                      imageController: _imageController,
                    ),
                    if (_currentIndex == AppConstants.pages.length - 1) ...[
                      SizedBox(height: context.height(0.01)),
                      Text(
                        "ابدأ الآن",
                        style: AppStyles.blue26regular.copyWith(
                          fontSize: context.sp(22),
                        ),
                      ),
                    ],
                    SizedBox(height: context.height(0.02))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
