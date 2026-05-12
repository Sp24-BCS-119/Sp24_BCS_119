import 'package:flutter/material.dart';
import '../models/weather_models.dart';

class WeatherHeroCard extends StatelessWidget {
  final WeatherData data;

  const WeatherHeroCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 400),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.withOpacity(0.4),
            const Color(0xFF0F172A).withOpacity(0.6),
          ],
        ),
        border: Border.all(color: Colors.indigo.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.temp}°',
                        style: const TextStyle(
                          fontSize: 110,
                          fontWeight: FontWeight.w100,
                          letterSpacing: -6,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data.description.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE0E7FF),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'H: ${data.tempMax}°  L: ${data.tempMin}°',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 16,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  Image.network(
                    'https://openweathermap.org/img/wn/${data.icon}@4x.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 48),
              // Hourly Micro-forecast Style UI
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMicroStat('FEELS LIKE', '${data.feelsLike}°'),
                    Container(width: 1, height: 32, color: Colors.white10),
                    _buildMicroStat('HUMIDITY', '${data.humidity}%'),
                    Container(width: 1, height: 32, color: Colors.white10),
                    _buildMicroStat('WIND', '${data.windSpeed.round()} KM/H', isHighlighted: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicroStat(String label, String value, {bool isHighlighted = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isHighlighted ? Colors.indigoAccent : Colors.white38,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            color: isHighlighted ? Colors.indigoAccent : Colors.white,
          ),
        ),
      ],
    );
  }
}
