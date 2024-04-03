class TemperatureModel {
  final double? temp;
  final double? tempMin;
  final double? tempMax;
  final double? feelsLike;
  final double? humidity;
  final int? pressure;
  final int? seaLevel;
  final int? grndLevel;
  

  TemperatureModel({
    this.temp,
    this.tempMin,
    this.tempMax,
    this.feelsLike,
    this.humidity,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
  });

  factory TemperatureModel.fromJson(Map<String, dynamic> json) {
    return TemperatureModel(
      temp: double.parse(json['temp'].toString()),
      tempMin: double.parse(json['temp_min'].toString()),
      tempMax: double.parse(json['temp_max'].toString()),
      feelsLike: double.parse(json['feels_like'].toString()),
      humidity: double.parse(json['humidity'].toString()),
      pressure: json['pressure'],
      seaLevel: json['sea_level'] ?? 0,
      grndLevel: json['grnd_level'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'temp_min': tempMin,
      'temp_max': tempMax,
      'feels_like': feelsLike,
      'humidity': humidity,
      'pressure': pressure,
      'sea_level': seaLevel,
      'grnd_level': grndLevel,
    };
  }
}
