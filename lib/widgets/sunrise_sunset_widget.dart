import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/utils/format_date_time.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/text.dart';

class SunriseSunsetWidget extends StatelessWidget {
  const SunriseSunsetWidget({
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
                text: 'Sunrise/Sunset',
                size: TextSize.lg,
                isBold: true,
                color: Colors.white,
              ),
              TextWidget(
                text: 'Time of sunrise and sunset',
                size: TextSize.sm,
                color: Colors.white,
              ),

              // Image.asset('assets/icons/sunrise.png', width: 100, height: 100),
              Lottie.asset('assets/images/sunrise_sunset.json', width: 100),
            ],
          ),
          SizedBox(
            width: cPadding,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    TextWidget(
                      text: 'Sunrise',
                      color: Colors.white,
                    ),
                    Image.asset(
                      'assets/icons/sunrise.png',
                      width: 25,
                      height: 25,
                      color: Colors.white,
                    ),
                    TextWidget(
                      text: formatDateTime(weatherViewModel.weather!.sunrise!, showWeekday: true),
                      color: Colors.white,
                    ),
                    TextWidget(
                      text: formatDateTime(weatherViewModel.weather!.sunrise!, showTime: true),
                      color: Colors.white,
                      isBold: true,
                    ),
                  ],
                ),
                SizedBox(
                  width: cPadding,
                ),
                Column(
                  children: [
                    TextWidget(
                      text: 'Sunset',
                      color: Colors.white,
                    ),
                    Image.asset(
                      'assets/icons/moon.png',
                      width: 25,
                      height: 25,
                      color: Colors.white,
                    ),
                    TextWidget(
                      text: formatDateTime(weatherViewModel.weather!.sunrise!, showWeekday: true),
                      color: Colors.white,
                    ),
                    TextWidget(
                      text: formatDateTime(weatherViewModel.weather!.sunset!, showTime: true),
                      color: Colors.white,
                      isBold: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
