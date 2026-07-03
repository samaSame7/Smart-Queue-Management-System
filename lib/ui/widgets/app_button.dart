import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPress,
    required this.text,
    this.bkColor = AppColors.blue,
    this.foreColor = AppColors.white,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
  });

  final VoidCallback? onPress;
  final String text;
  final Color? bkColor;
  final Color? foreColor;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final bool effectiveDisabled = isDisabled || isLoading || onPress == null;

    return GestureDetector(
      onTap: effectiveDisabled ? null : onPress,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: effectiveDisabled ? AppColors.gray : bkColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!effectiveDisabled)
              BoxShadow(
                color: AppColors.darkBlue.withAlpha(20),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: foreColor,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 26,
                        color: effectiveDisabled ? AppColors.darkBlue.withOpacity(0.5) : foreColor,
                      ),
                      const SizedBox(width: 18),
                    ],
                    Expanded(
                      child: Text(
                        text,
                        style: AppStyles.white20regular.copyWith(
                          color: effectiveDisabled ? AppColors.darkBlue.withOpacity(0.5) : foreColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
