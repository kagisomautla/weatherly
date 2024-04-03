import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/colors.dart';
import 'package:weatherly/screens/no_internet_connection_screen.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/viewmodels/weather_view_model.dart';
import 'package:http/http.dart' as http;

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  init() async {
    bool hasOnboarded = await LocalStorageService.getOnboardingStatus();
    final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);

    if (hasOnboarded) {
      //fetch last updated weather data from local storage
      await weatherViewModel.fetchOfflineWeatherInformation(context: context);

      print('Has onboarded... Take to welcome screen');
      //navigate to welcome screen
      Navigator.pushNamedAndRemoveUntil(context, '/navigator', (route) => false);
    } else {
      //navigate to onboarding screen
      print('Has NOT  onboarded... Take to onboading screen');
      await checkForInternetConnectivity().then((value) {
        if (value) {
          Navigator.pushNamedAndRemoveUntil(context, '/onboarding', (route) => false);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NoInternetConnectionScreen(
                showRetryButton: true,
                onRetry: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingScreen()));
                },
              ),
            ),
          );
        }
      });
    }
  }

  Future<bool> checkForInternetConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    bool isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi);

    if (!isConnected) {
      return false;
    } else {
      //check if the device has internet connection by doing a dummy search
      final response = await http.get(Uri.parse('https://www.google.com'));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSunnyBackgroundColor,
      body: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          height: 80,
          width: 80,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Image.asset(
            'assets/icons/app_icon.png',
            height: 100,
            width: 100,
          ),
        ),
      ),
    );
  }
}
