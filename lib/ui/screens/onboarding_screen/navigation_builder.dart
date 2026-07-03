import 'package:flutter/material.dart';
import '../../../core/utils/responsive_extensions.dart';
import '../../utils/app_colors.dart';
import '../../widgets/app_constants.dart';

class NavigationBuilder extends StatelessWidget {
  final int currentIndex;

  const NavigationBuilder({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        AppConstants.pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: context.width(0.01)),
          height: context.height(0.01),
          width: currentIndex == index ? context.width(0.1) : context.width(0.02),
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.blue
                : AppColors.darkBlue.withAlpha(75),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
