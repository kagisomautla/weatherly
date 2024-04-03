import 'package:mockito/annotations.dart';
import 'package:weatherly/domains/repositories/forecast_repository.dart';
import 'package:weatherly/domains/repositories/google_place_repository.dart';
import 'package:weatherly/domains/repositories/weather_repository.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    WeatherRepository,
    ForecastRepository,
    GooglePlaceRepository,
  ],
  customMocks: [
    MockSpec<http.Client>(as: #MockHttpClient),
    MockSpec<http.Response>(as: #MockHttpResponse),
  ],
)
void main() {}
