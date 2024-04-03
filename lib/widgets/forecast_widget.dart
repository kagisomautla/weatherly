import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/models/Forecast.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/text.dart';

class ForecastListView extends StatefulWidget {
  final List<ForecastModel> forecast;
  const ForecastListView({super.key, required this.forecast});

  @override
  State<ForecastListView> createState() => _ForecastListViewState();
}

class _ForecastListViewState extends State<ForecastListView> {
  @override
  Widget build(BuildContext context) {
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: cPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: 'Forecast',
              size: TextSize.lg,
              isBold: true,
              color: Colors.white,
            ),
            TextWidget(
              text: 'For the next 5 days',
              size: TextSize.sm,
              color: Colors.white,
            ),
            SizedBox(
              height: cPadding,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.forecast.map(
                (e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: cPadding / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: e.dayOfTheWeek,
                                isBold: true,
                                color: Colors.white,
                              ),
                              TextWidget(
                                text: e.description,
                                size: TextSize.sm,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        weatherViewModel.isOnline
                            ? Image.network(
                                'https://openweathermap.org/img/w/${e.icon}.png',
                                width: 40,
                                height: 40,
                              )
                            : Container(),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextWidget(
                                text: '${e.temperature!.temp.toString()}°',
                                color: Colors.white,
                                isBold: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        ));
  }
}

class ForecastListItem {
  final String cityName;
  final String description;
  final IconData icon;
  final String? temperature;

  ForecastListItem({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
  });
}
