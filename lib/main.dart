import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/screens/favourites_screen.dart';
import 'package:weatherly/screens/home_screen.dart';
import 'package:weatherly/screens/landing_screen.dart';
import 'package:weatherly/screens/maps.dart';
import 'package:weatherly/screens/navigator_screen.dart';
import 'package:weatherly/screens/onboarding_screen.dart';
import 'package:weatherly/screens/search_screen.dart';
import 'package:weatherly/viewmodels/coordinates_view_model.dart';
import 'package:weatherly/viewmodels/google_maps_view_model.dart';
import 'package:weatherly/viewmodels/locations_view_model.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';

Future main() async {
  await dotenv.load(fileName: 'assets/env/dev.env');
  runApp(const WeatherlyApplication());
}

class WeatherlyApplication extends StatelessWidget {
  const WeatherlyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // LocalStorageService.clearAllData();

    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherViewModel>(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider<CoordinatesViewModel>(create: (_) => CoordinatesViewModel()),
        ChangeNotifierProvider<ThemeViewModel>(create: (_) => ThemeViewModel()),
        ChangeNotifierProvider<LocationViewModel>(create: (_) => LocationViewModel()),
        ChangeNotifierProvider<GoogleMapsViewModel>(create: (_) => GoogleMapsViewModel()),
      ],
      child: MaterialApp(
        key: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => LandingScreen(),
          '/onboarding': (BuildContext context) => OnboardingScreen(),
          '/navigator': (BuildContext context) => NavigatorScreen(navigatorKey: navigatorKey),
          '/home': (BuildContext context) => HomeScreen(),
          '/maps': (BuildContext context) => GoogleMapScreen(navigatorKey: navigatorKey),
          '/search': (BuildContext context) => SearchScreen(),
          '/favourites': (BuildContext context) => FavouritesScreen(),
        },
      ),
    );
  }
}
