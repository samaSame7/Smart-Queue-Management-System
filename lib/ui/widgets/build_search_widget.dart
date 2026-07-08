import 'package:flutter/material.dart';
import '../../core/utils/responsive_extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class BuildSearchWidget extends StatelessWidget {
  const BuildSearchWidget({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: context.height(0.055),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBlue.withAlpha(26),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          cursorColor: AppColors.blue,
          style: AppStyles.blue16regular.copyWith(
            fontSize: context.sp(16),
          ),
          decoration: InputDecoration(
            hintText: 'بحث ...',
            hintStyle: AppStyles.gray16regular.copyWith(
              fontSize: context.sp(16),
              color: AppColors.darkBlue.withAlpha(128),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.width(0.04),
              vertical: context.height(0.012),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.blue,
              size: context.sp(22),
            ),
          ),
        ),
      ),
    );
  }
}
