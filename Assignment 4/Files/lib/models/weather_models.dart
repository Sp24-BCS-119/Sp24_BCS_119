class WeatherData {
  final String city;
  final String country;
  final int temp;
  final int feelsLike;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final double visibility;
  final int sunrise;
  final int sunset;
  final int tempMin;
  final int tempMax;

  WeatherData({
    required this.city,
    required this.country,
    required this.temp,
    required this.feelsLike,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.tempMin,
    required this.tempMax,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['name'],
      country: json['sys']['country'],
      temp: (json['main']['temp'] as num).round(),
      feelsLike: (json['main']['feels_like'] as num).round(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'],
      visibility: (json['visibility'] as num) / 1000.0,
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      tempMin: (json['main']['temp_min'] as num).round(),
      tempMax: (json['main']['temp_max'] as num).round(),
    );
  }
}

class ForecastData {
  final int dt;
  final int temp;
  final String description;
  final String icon;

  ForecastData({
    required this.dt,
    required this.temp,
    required this.description,
    required this.icon,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      dt: json['dt'],
      temp: (json['main']['temp'] as num).round(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
