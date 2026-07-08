import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../onboarding_screen/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = "splashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.babyBlue,
        body: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                AppAssets.fciLogo,
                height: 150,
                alignment: AlignmentGeometry.topLeft,
              ),
              const SizedBox(
                height: 100,
              ),
              const Text(
                'مرحبا بكم',
                style: AppStyles.blue50regular,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'في منصة خدمات كلية الحاسبات والمعلومات',
                style: AppStyles.blue26regular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
