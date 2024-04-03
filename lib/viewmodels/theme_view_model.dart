import 'package:flutter/material.dart';
import 'package:weatherly/constants/colors.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/models/Weather.dart';

class ThemeViewModel extends ChangeNotifier {
  int _currentPage = 0;
  String? _icon;
  Color? _color;
  String? _name;
  String? _backgroundImage;

  String? get icon => _icon;
  Color? get color => _color;
  String? get name => _name;
  String? get image => _backgroundImage;
  int get currentPage => _currentPage;

  set icon(String? value) {
    _icon = value;
    notifyListeners();
  }

  set color(Color? value) {
    _color = value;
    notifyListeners();
  }

  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  set image(String? value) {
    _backgroundImage = value;
    notifyListeners();
  }

  set currentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setTheme(WeatherModel weather) {
    print('SETTING THEME...');
    // print(weather.toJson());
    switch (weather.main.toLowerCase()) {
      case 'clear':
      case 'sunny':
        _icon = weather.icon;
        _color = kSunnyBackgroundColor;
        _name = weather.main;
        _backgroundImage = kSunnyBackgroundImage;
        break;
      case 'clouds':
        _icon = weather.icon;
        _color = kCloudyBackgroundColor;
        _name = weather.main == 'Clouds' ? 'Cloudy' : 'Misty';
        _backgroundImage = kCloudyBackgroundImage;
        break;
      case 'rain':
      case 'thuderstorm':
      case 'drizzle':
      case 'snow':
        _icon = weather.icon;
        _color = kRainyBackgroundColor;
        _name = weather.main;
        _backgroundImage = kRainyBackgroundImage;
        break;
      default:
        _icon = weather.icon;
        _color = kSunnyBackgroundColor;
        _name = weather.main;
        _backgroundImage = kSunnyBackgroundImage;
    }

    notifyListeners();
  }
}
