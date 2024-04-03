import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/colors.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/loader.dart';
import 'package:weatherly/widgets/text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() async {
    final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    if (!mounted) return;
    await weatherViewModel.performOnboard(context: context).then((_) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/navigator');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kCloudyBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(cPadding),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Welcome to Weatherly',
                      isBold: true,
                      size: TextSize.lg,
                      color: Colors.white,
                    ),
                    Lottie.asset(
                      'assets/images/onboarding.json',
                      height: 200,
                      width: 200,
                    ),
                    LoaderWidget(
                      color: Colors.white,
                    ),
                    TextWidget(
                      text: 'Loading data for the first time. Please wait...',
                      color: Colors.white,
                      isBold: true,
                    )
                  ],
                ),
              ),
              TextWidget(
                text: 'Powered by OpenWeatherMap',
                isBold: true,
                size: TextSize.normal,
                color: Colors.white,
              ),
              SizedBox(
                height: 5,
              ),
              TextWidget(
                text: 'Created by Kagiso Mautla',
                isBold: true,
                size: TextSize.sm,
                color: Colors.white,
              ),
              SizedBox(
                height: cPadding,
              ),
            ],
          ),
        ));
  }
}
