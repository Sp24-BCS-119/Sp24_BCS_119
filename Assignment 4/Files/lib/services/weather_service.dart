import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_models.dart';

class WeatherService {
  static const String apiKey = 'd90c1095371557e6e73b2e8081ccab84';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherData> fetchWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/weather?q=$city&units=metric&appid=$apiKey'));
    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<WeatherData> fetchWeatherByCoords(double lat, double lon) async {
    final response = await http.get(Uri.parse('$baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey'));
    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  Future<List<ForecastData>> fetchForecast(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/forecast?q=$city&units=metric&appid=$apiKey'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['list'];
      return list
          .where((item) => item['dt_txt'].contains('12:00:00'))
          .map((item) => ForecastData.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}
