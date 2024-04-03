import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/widgets/snackbar.dart';
import '../viewmodels/weather_view_model.dart';

class InternetService {
  InternetService();
  static final _instance = InternetService();
  static InternetService get instance => _instance;
  late StreamSubscription<List<ConnectivityResult>> subscription;
  ConnectivityResult previousResult = ConnectivityResult.none;

  initialConnection({required BuildContext context}) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    final WeatherViewModel weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);

    if (connectivityResult.contains(ConnectivityResult.none)) {
      weatherViewModel.showLastUpdated = true;
      weatherViewModel.isOnline = false;
      // No network available.
      snackBar(message: 'You are not connected to the internet', context: context);
    }

    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      // Check if the current connectivity status is different from the previous one.
      if (!listEquals(result, [previousResult])) {
        previousResult = result.first; // Update the previous connectivity status.

        // Display snack bar based on the current connectivity status.
        if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
          // Mobile network available.
          weatherViewModel.showLastUpdated = false;
          weatherViewModel.isOnline = true;
          snackBar(message: 'You are connected to the internet', context: context);
        } else if (result.contains(ConnectivityResult.none)) {
          print('No internet connection');

          weatherViewModel.showLastUpdated = true;
          weatherViewModel.isOnline = false;
          // No network available.
          snackBar(message: 'You are not connected to the internet', context: context);
        }
      }
    });
  }

  void disposeStream() => subscription.cancel();
}
