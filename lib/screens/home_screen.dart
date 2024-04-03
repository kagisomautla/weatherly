import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/utils/format_date_time.dart';
import 'package:weatherly/viewmodels/locations_view_model.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:weatherly/widgets/current_weather_widget.dart';
import 'package:weatherly/widgets/favourite_widget.dart';
import 'package:weatherly/widgets/forecast_widget.dart';
import 'package:weatherly/widgets/humidity_widget.dart';
import 'package:weatherly/widgets/loader.dart';
import 'package:weatherly/widgets/sunrise_sunset_widget.dart';
import 'package:weatherly/widgets/text.dart';
import 'package:weatherly/widgets/wind_speed_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool syncing = false;
  bool showRain = false;

  determineShowRain(String main) {
    if (main.toLowerCase().contains('rain')) {
      setState(() {
        showRain = true;
      });
    } else {
      setState(() {
        showRain = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  init() async {
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    final locationViewModel = Provider.of<LocationViewModel>(context);
    final themeVM = Provider.of<ThemeViewModel>(context);
    determineShowRain(weatherViewModel.weather?.main ?? '');

    return Scaffold(
        backgroundColor: themeVM.color,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 100,
          leading: sync(context),
          actions: [
            Row(
              children: [
                IconButton(
                  icon: Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                FavouriteWidget(
                  location: locationViewModel.location!,
                )
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(seconds: 5),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset(
                      themeVM.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(seconds: 2),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        children: [
                          TextWidget(
                            text: '${weatherViewModel.weather!.temperature!.temp}°',
                            size: TextSize.xl,
                            isBold: true,
                            color: Colors.white,
                          ),
                          TextWidget(
                            text: weatherViewModel.weather!.main,
                            color: Colors.white,
                          ),
                          weatherViewModel.isOnline ? Image.network('https://openweathermap.org/img/w/${weatherViewModel.weather!.icon}.png') : Container(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  locationViewModel.location != null
                      ? Positioned(
                          top: 10,
                          child: !weatherViewModel.isOnline
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: cPadding,
                                    ),
                                    Icon(
                                      Icons.wifi_off,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget(
                                      text: 'You are not connected to the internet.',
                                      color: Colors.white,
                                      isBold: true,
                                    )
                                  ],
                                )
                              : Container(),
                        )
                      : Container(),
                  Positioned(
                    bottom: MediaQuery.of(context).padding.top * 3,
                    child: Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.mapPin,
                          color: const Color.fromARGB(255, 255, 17, 0),
                          size: 14,
                        ),
                        TextWidget(
                          text: weatherViewModel.weather?.cityName ?? '',
                          color: Colors.white,
                          size: TextSize.md,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      left: 10,
                      bottom: 10,
                      child: TextWidget(
                        text: 'Last Updated: ${formatDateTime(
                          weatherViewModel.weather!.lastUpdated,
                          showWeekDayAndTime: true,
                        )}',
                        color: Colors.white,
                      )),
                  showRain
                      ? Positioned.fill(
                          child: Lottie.asset('assets/images/rain.json'),
                        )
                      : Container(),
                ],
              ),
              CurrentTemperatureWidget(
                min: weatherViewModel.weather!.temperature!.tempMin.toString(),
                current: weatherViewModel.weather!.temperature!.temp.toString(),
                max: weatherViewModel.weather!.temperature!.tempMax.toString(),
              ),
              ForecastListView(
                forecast: weatherViewModel.forecast ?? [],
              ),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              WindSpeedWidget(weatherViewModel: weatherViewModel),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              weatherViewModel.weather!.temperature!.humidity != null ? HumidityWidget(weatherViewModel: weatherViewModel, themeVM: themeVM) : Container(),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              weatherViewModel.weather!.sunrise != null && weatherViewModel.weather!.sunset != null ? SunriseSunsetWidget(weatherViewModel: weatherViewModel) : Container(),
            ],
          ),
        ));
  }

  GestureDetector sync(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
        setState(() {
          syncing = true;
        });
        await weatherViewModel.sync(context: context).then((_) {
          setState(() {
            syncing = false;
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: cPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            syncing ? LoaderWidget() : Icon(FontAwesomeIcons.arrowsRotate, color: Colors.white),
            SizedBox(
              width: cPadding,
            ),
            syncing
                ? Container()
                : TextWidget(
                    text: 'Sync',
                    color: Colors.white,
                    isBold: true,
                  ),
          ],
        ),
      ),
    );
  }
}
