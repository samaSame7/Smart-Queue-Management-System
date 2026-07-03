import 'package:flutter/material.dart';
import '../../../core/utils/responsive_extensions.dart';
import '../../utils/app_colors.dart';
import '../../widgets/app_constants.dart';
import '../main_screen/main_screen.dart';

class BuildElevatedButton extends StatelessWidget {
  const BuildElevatedButton({
    super.key,
    required this.currentIndex,
    required this.imageController,
  });
  final int currentIndex;
  final PageController imageController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (currentIndex == AppConstants.pages.length - 1) {
          Navigator.pushReplacementNamed(context, MainScreen.routeName);
        } else {
          imageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(context.width(0.04)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.blue,
        elevation: 0,
      ),
      child: Icon(
        Icons.arrow_forward_rounded,
        size: context.sp(32),
      ),
    );
  }
}
