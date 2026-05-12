import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'models/weather_models.dart';
import 'services/weather_service.dart';
import 'widgets/weather_hero_card.dart';
import 'widgets/stats_grid.dart';
import 'widgets/forecast_strip.dart';

void main() {
  runApp(const SkyCastApp());
}

class SkyCastApp extends StatelessWidget {
  const SkyCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyCast Weather',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: const Color(0xFF020617),
      ),
      debugShowCheckedModeBanner: false,
      home: const WeatherHomeScreen(),
    );
  }
}

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final WeatherService _service = WeatherService();
  WeatherData? _weather;
  List<ForecastData>? _forecast;
  bool _isLoading = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeather('San Francisco');
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final weather = await _service.fetchWeather(city);
      final forecast = await _service.fetchForecast(city);
      setState(() {
        _weather = weather;
        _forecast = forecast;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF1E1B4B), Color(0xFF020617)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 1000;
              
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 64.0 : 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isWide),
                    const SizedBox(height: 48),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator(color: Colors.indigoAccent))
                          : _error != null
                              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.redAccent)))
                              : _weather == null
                                  ? _buildEmptyState()
                                  : SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          if (isWide)
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(flex: 7, child: WeatherHeroCard(data: _weather!)),
                                                const SizedBox(width: 32),
                                                Expanded(flex: 5, child: StatsGrid(data: _weather!)),
                                              ],
                                            )
                                          else
                                            Column(
                                              children: [
                                                WeatherHeroCard(data: _weather!),
                                                const SizedBox(height: 24),
                                                StatsGrid(data: _weather!),
                                              ],
                                            ),
                                          const SizedBox(height: 48),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '5-DAY FORECAST Strip',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2,
                                                color: Colors.white54,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          if (_forecast != null) ForecastStrip(forecasts: _forecast!),
                                          const SizedBox(height: 40),
                                          const Text(
                                            'SKYCAST INTELLIGENCE • DATA FROM OPENWEATHER',
                                            style: TextStyle(fontSize: 9, color: Colors.white10, letterSpacing: 2, fontFamily: 'monospace'),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_queue, size: 80, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 24),
          const Text('Search for a city to begin', style: TextStyle(color: Colors.white24, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isWide) {
    return Flex(
      direction: isWide ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: isWide ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w200, letterSpacing: -1),
                children: [
                  TextSpan(text: _weather?.city ?? 'SkyCast'),
                  const TextSpan(text: ', ', style: TextStyle(color: Colors.white24)),
                  TextSpan(text: _weather?.country ?? 'Forecast', style: const TextStyle(color: Colors.white24)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()).toUpperCase(),
              style: const TextStyle(fontSize: 10, color: Colors.white38, letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (!isWide) const SizedBox(height: 24),
        Container(
          width: isWide ? 400 : double.infinity,
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: Colors.white38),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onSubmitted: _fetchWeather,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search for a city...',
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
