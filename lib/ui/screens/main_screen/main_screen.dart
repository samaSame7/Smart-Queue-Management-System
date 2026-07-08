import 'package:flutter/material.dart';
import '../../../core/utils/responsive_extensions.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/app_button.dart';
import '../booking_screen/booking_screen.dart';
import '../common_questions_screen/common_questions_screen.dart';
import '../service_requirement_screen/service_requirement_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static const String routeName = "mainScreen";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.height(0.02)),
                    const Text(
                      "ازاي نقدر نساعدك؟",
                      style: AppStyles.blue34regular,
                    ),
                    SizedBox(height: context.height(0.03)),
                    Image.asset(
                      AppAssets.mainImg,
                      height: context.height(0.35),
                    ),
                    SizedBox(height: context.height(0.05)),
                    AppButton(
                      text: "الاسئلة الشائعة",
                      icon: Icons.question_answer_rounded,
                      onPress: () {
                        Navigator.pushNamed(context, FaqScreen.routeName);
                      },
                      bkColor: AppColors.blue,
                    ),
                    SizedBox(height: context.height(0.025)),
                    AppButton(
                      text: "متطلبات الخدمات",
                      icon: Icons.list_alt_rounded,
                      onPress: () {
                        Navigator.pushNamed(
                            context, ServiceRequirementScreen.routeName);
                      },
                      bkColor: AppColors.blue,
                    ),
                    SizedBox(height: context.height(0.025)),
                    AppButton(
                      text: "احجز دورك الآن",
                      icon: Icons.assignment_turned_in_rounded,
                      onPress: () {
                        Navigator.pushNamed(context, BookingScreen.routeName);
                      },
                      bkColor: AppColors.blue,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
