import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import 'faq_dm.dart';

class BuildServiceWidget extends StatelessWidget {
  const BuildServiceWidget({
    super.key,
    required this.item,
    required this.isOpen,
    required this.onExpansionChanged,
  });

  final FaqDm item;
  final bool isOpen;
  final Function(bool) onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(7),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          key: Key('${item.id}-$isOpen'),
          initiallyExpanded: isOpen,
          onExpansionChanged: onExpansionChanged,
          collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            item.title,
            textAlign: TextAlign.right,
            style: AppStyles.blue26regular.copyWith(fontSize: 22),
          ),
          trailing: Icon(
            isOpen
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: AppColors.darkBlue,
          ),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                item.content,
                textAlign: TextAlign.right,
                style: AppStyles.blue16regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}