import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/text.dart';

class HumidityWidget extends StatelessWidget {
  const HumidityWidget({
    super.key,
    required this.weatherViewModel,
    required this.themeVM,
  });

  final WeatherViewModel weatherViewModel;
  final ThemeViewModel themeVM;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(cPadding),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: 'Humidity',
                size: TextSize.lg,
                isBold: true,
                color: Colors.white,
              ),
              TextWidget(
                text: 'Amount of water vapor in the air',
                size: TextSize.sm,
                color: Colors.white,
              ),
              SizedBox(
                height: cPadding,
              ),
              CircularPercentIndicator(
                radius: 50.0,
                animation: true,
                animationDuration: 2000,
                lineWidth: 5.0,
                percent: weatherViewModel.weather!.temperature!.humidity! / 100,
                center: TextWidget(
                  text: '${weatherViewModel.weather!.temperature!.humidity}%',
                  size: TextSize.md,
                  color: Colors.white,
                  isBold: true,
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white,
                progressColor: themeVM.color?.withOpacity(0.6) ?? Colors.black.withOpacity(0.5),
              ),
            ],
          ),
          SizedBox(
            width: cPadding,
          ),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  TextWidget(
                    text: 'Feels Like',
                    color: Colors.white,
                  ),
                  TextWidget(
                    text: '${weatherViewModel.weather!.temperature!.feelsLike}°',
                    size: TextSize.md,
                    color: Colors.white,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
