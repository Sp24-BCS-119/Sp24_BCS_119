import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_models.dart';

class ForecastStrip extends StatelessWidget {
  final List<ForecastData> forecasts;

  const ForecastStrip({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        padding: const EdgeInsets.only(bottom: 8),
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = forecasts[index];
          final date = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
          final isToday = index == 0;
          
          return Container(
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isToday ? Colors.indigoAccent.withOpacity(0.3) : Colors.white.withOpacity(0.05),
                width: isToday ? 1.5 : 1,
              ),
              boxShadow: isToday ? [BoxShadow(color: Colors.indigoAccent.withOpacity(0.1), blurRadius: 10)] : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEE').format(date).toUpperCase(),
                  style: TextStyle(
                    fontSize: 11, 
                    fontWeight: FontWeight.bold, 
                    color: isToday ? Colors.indigoAccent : Colors.white38,
                    letterSpacing: 1.2,
                  ),
                ),
                Image.network(
                  'https://openweathermap.org/img/wn/${item.icon}@2x.png',
                  width: 48,
                  height: 48,
                ),
                Column(
                  children: [
                    Text(
                      '${item.temp}°',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM d').format(date).toUpperCase(),
                      style: const TextStyle(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
