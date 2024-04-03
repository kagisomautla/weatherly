import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherly/constants/colors.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/widgets/loader.dart';
import 'package:weatherly/widgets/text.dart';

class LoadingScreen extends StatefulWidget {
  final String? message;
  const LoadingScreen({super.key, this.message});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
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
                      text: 'Weatherly',
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
                      text: widget.message ?? 'Loading. Please wait...',
                      color: Colors.white,
                      isBold: true,
                    )
                  ],
                ),
              ),
              TextWidget(
                text: 'Powered by OpenWeatherMap',
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
