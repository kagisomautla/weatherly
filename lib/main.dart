
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/screens/home_screen.dart';
import 'package:weatherly/screens/landing_screen.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';

Future main() async {
  await dotenv.load(fileName: 'assets/.env');
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherViewModel>(create: (_) => WeatherViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => LandingScreen(),
          '/home': (BuildContext context) => HomeScreen(),
        },
      ),
    );
  }
}
