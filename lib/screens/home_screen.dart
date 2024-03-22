import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/weather_types.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  initState() {
    super.initState();

    //fetch the weather data
    final weatherProvider = Provider.of<WeatherViewModel>(context, listen: false);
    weatherProvider.fetchWeather(types: WeatherTypes.weather, latitude: '37.7749', longitude: '-122.4194');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}
