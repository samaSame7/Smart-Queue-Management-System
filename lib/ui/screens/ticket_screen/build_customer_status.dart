import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class BuildCustomerStatus extends StatelessWidget {
  const BuildCustomerStatus({
    super.key,
    required this.decoration,
    required this.statusLabel,
    this.statusColor,
    this.statusTextColor,
  });

  final BoxDecoration decoration;
  final String statusLabel;
  final Color? statusColor;
  final Color? statusTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
            decoration: BoxDecoration(
              color: statusColor ?? AppColors.gray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusLabel,
              style: AppStyles.blue16regular.copyWith(
                color: statusTextColor ?? AppColors.darkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Row(
            children: [
              Text.rich(
                TextSpan(
                  text: "الحالة",
                  style: AppStyles.blue16regular,
                  children: [
                    TextSpan(
                      text: ":\u200F",
                      style: AppStyles.blue16regular,
                    )
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.edit, color: AppColors.darkBlue),
            ],
          ),
        ],
      ),
    );
  }
}
