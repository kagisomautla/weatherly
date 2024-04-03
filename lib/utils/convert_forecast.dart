import 'package:weatherly/models/Forecast.dart';
import 'package:weatherly/models/Temperature.dart';
import 'package:weatherly/models/Weather.dart';
import 'package:weatherly/utils/format_date_time.dart';
import 'package:weatherly/utils/get_week_day.dart';

Future<List<ForecastModel>> formatFiveDayForecast(dynamic data) async {
  final List<dynamic> forecastList = data['list'];
  final Map<String, List<dynamic>> groupedForecast = _groupForecastByDate(forecastList);
  final List<ForecastModel> dailyAverages = _calculateDailyAverages(groupedForecast);
  return dailyAverages;
}

Map<String, List<dynamic>> _groupForecastByDate(List<dynamic> forecastList) {
  // Group forecast records by date
  final Map<String, List<dynamic>> groupedForecast = {};
  forecastList.forEach((forecast) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);

    final String dateKey = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    if (!groupedForecast.containsKey(dateKey)) {
      groupedForecast[dateKey] = [];
    }
    groupedForecast[dateKey]!.add(forecast);
  });
  return groupedForecast;
}

List<ForecastModel> _calculateDailyAverages(Map<String, List<dynamic>> groupedForecast) {
  // Calculate averages for each day
  final List<ForecastModel> dailyAverages = [];

  groupedForecast.forEach((date, forecasts) {
    double sumTemperature = 0;
    double sumHumidity = 0;
    double sumWindSpeed = 0;
    double sumPressure = 0;
    double sumSeaLevel = 0;
    double sumGroundLevel = 0;
    double sumFeelsLike = 0;
    List<String> weatherIcons = [];
    int count = forecasts.length;

    forecasts.forEach((forecast) {
      sumTemperature += forecast['main']['temp'];
      sumHumidity += forecast['main']['humidity'];
      sumWindSpeed += forecast['wind']['speed'];
      sumPressure += forecast['main']['pressure'];
      sumSeaLevel += forecast['main']['sea_level'];
      sumGroundLevel += forecast['main']['grnd_level'];
      sumFeelsLike += forecast['main']['feels_like'];
      weatherIcons.add(forecast['weather'][0]['icon'].toString());
    });

    final double averageTemperature = sumTemperature / count;
    final double averageHumidity = sumHumidity / count;
    final double averageWindSpeed = sumWindSpeed / count;
    final double averagePressure = sumPressure / count;
    final double averageSeaLevel = sumSeaLevel / count;
    final double averageGroundLevel = sumGroundLevel / count;
    final String description = forecasts[0]['weather'][0]['description'].toString();
    final double averageFeelsLike = sumFeelsLike / count;

    // Convert date to weekday name
    final DateTime dateTime = DateTime.parse(date);
    final String weekday = getWeekdayName(dateTime.weekday);

    dailyAverages.add(
      ForecastModel(
        dayOfTheWeek: formatDateTime(dateTime, showWeekday: true),
        temperature: TemperatureModel(
          // average temperature to two decimal places
          temp: double.parse(averageTemperature.toStringAsFixed(2)),
          tempMin: 0,
          tempMax: 0,
          humidity: averageHumidity,
          pressure: averagePressure.toInt(),
          seaLevel: averageSeaLevel.toInt(),
          grndLevel: averageGroundLevel.toInt(),
          feelsLike: averageFeelsLike,
        ),
        description: description,
        icon: weatherIcons[0],
        main: description,
      ),
    );
  });
  return dailyAverages;
}
