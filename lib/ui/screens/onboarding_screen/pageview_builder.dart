import 'package:flutter/material.dart';
import '../../widgets/app_constants.dart';

class PageviewBuilder extends StatelessWidget {
  final PageController pageController;
  final Function(int) onPageChanged;

  const PageviewBuilder({
    super.key,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: AppConstants.pages.length,
      onPageChanged: onPageChanged,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var page = AppConstants.pages[index];
        return Image.asset(
          page['image']!,
          fit: BoxFit.fill,
          width: double.infinity,
        );
      },
    );
  }
}
