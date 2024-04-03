import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/text.dart';

class WindSpeedWidget extends StatelessWidget {
  const WindSpeedWidget({
    super.key,
    required this.weatherViewModel,
  });

  final WeatherViewModel weatherViewModel;

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
                text: 'Wind Speed',
                size: TextSize.lg,
                isBold: true,
                color: Colors.white,
              ),
              TextWidget(
                text: 'Speed of the wind in the city',
                size: TextSize.sm,
                color: Colors.white,
              ),
              Lottie.asset(
                'assets/images/wind.json',
                width: 100,
              ),
            ],
          ),
          SizedBox(
            width: cPadding,
          ),
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Speed',
                    color: Colors.white,
                  ),
                  TextWidget(
                    text: '${weatherViewModel.weather!.windSpeed} m/s',
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
