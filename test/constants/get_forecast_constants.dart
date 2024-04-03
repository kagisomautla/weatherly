import 'package:weatherly/models/Forecast.dart';
import 'package:weatherly/models/Temperature.dart';

final expectedForecast = [
  ForecastModel(
    dayOfTheWeek: 'Monday',
    temperature: TemperatureModel(
      temp: 20.0,
      tempMin: 15.0,
      tempMax: 25.0,
    ),
    description: 'Cloudy',
    icon: '04d',
    main: 'Clouds',
  ),
  ForecastModel(
    dayOfTheWeek: 'Tuesday',
    temperature: TemperatureModel(
      temp: 22.0,
      tempMin: 17.0,
      tempMax: 27.0,
    ),
    description: 'Sunny',
    icon: '01d',
    main: 'Clear',
  ),
  ForecastModel(
    dayOfTheWeek: 'Wednesday',
    temperature: TemperatureModel(
      temp: 24.0,
      tempMin: 19.0,
      tempMax: 29.0,
    ),
    description: 'Rainy',
    icon: '10d',
    main: 'Rain',
  ),
  ForecastModel(
    dayOfTheWeek: 'Thursday',
    temperature: TemperatureModel(
      temp: 26.0,
      tempMin: 21.0,
      tempMax: 31.0,
    ),
    description: 'Snowy',
    icon: '13d',
    main: 'Snow',
  ),
  ForecastModel(
    dayOfTheWeek: 'Friday',
    temperature: TemperatureModel(
      temp: 28.0,
      tempMin: 23.0,
      tempMax: 33.0,
    ),
    description: 'Windy',
    icon: '50d',
    main: 'Mist',
  ),
];

final testForecastData = {
  'city': {
    'name': 'Minneapolis',
  },
  'list': [
    {
      'dt': 1630009200,
      'main': {
        'temp': 20.0,
        'temp_min': 15.0,
        'temp_max': 25.0,
      },
      'weather': [
        {
          'description': 'Cloudy',
          'icon': '04d',
          'main': 'Clouds',
        },
      ],
    },
    {
      'dt': 1630095600,
      'main': {
        'temp': 22.0,
        'temp_min': 17.0,
        'temp_max': 27.0,
      },
      'weather': [
        {
          'description': 'Sunny',
          'icon': '01d',
          'main': 'Clear',
        },
      ],
    },
    {
      'dt': 1630182000,
      'main': {
        'temp': 24.0,
        'temp_min': 19.0,
        'temp_max': 29.0,
      },
      'weather': [
        {
          'description': 'Rainy',
          'icon': '10d',
          'main': 'Rain',
        },
      ],
    },
    {
      'dt': 1630268400,
      'main': {
        'temp': 26.0,
        'temp_min': 21.0,
        'temp_max': 31.0,
      },
      'weather': [
        {
          'description': 'Snowy',
          'icon': '13d',
          'main': 'Snow',
        },
      ],
    },
    {
      'dt': 1630354800,
      'main': {
        'temp': 28.0,
        'temp_min': 23.0,
        'temp_max': 33.0,
      },
      'weather': [
        {
          'description': 'Windy',
          'icon': '50d',
          'main': 'Mist',
        },
      ],
    },
  ],
};
