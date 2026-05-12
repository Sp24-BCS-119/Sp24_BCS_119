import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_models.dart';

class StatsGrid extends StatelessWidget {
  final WeatherData data;

  const StatsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.25,
          children: [
            _buildStatCard('Visibility', '${data.visibility} km', Icons.visibility_outlined, sub: 'Clear view'),
            _buildStatCard('Pressure', '${data.pressure} hPa', Icons.speed, sub: 'Stable'),
            _buildStatCard('Humidity', '${data.humidity}%', Icons.water_drop_outlined, progress: data.humidity.toDouble() / 100),
            _buildStatCard('Wind Speed', '${data.windSpeed.round()} km/h', Icons.air, sub: 'NW Direction'),
          ],
        ),
        const SizedBox(height: 16),
        _buildWideCard('Sun Cycle', [
          _buildSunInfo('SUNRISE', DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(data.sunrise * 1000)), Icons.wb_sunny_outlined),
          _buildSunInfo('SUNSET', DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(data.sunset * 1000)), Icons.nightlight_outlined),
        ]),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, {String? sub, double? progress}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Icon(icon, size: 16, color: Colors.indigoAccent.withOpacity(0.5)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: Colors.white)),
              const SizedBox(height: 4),
              if (sub != null)
                Text(sub.toUpperCase(), style: const TextStyle(fontSize: 9, color: Colors.indigoAccent, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              if (progress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white10,
                      color: Colors.indigoAccent,
                      minHeight: 3,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWideCard(String label, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1) const SizedBox(width: 48),
              ],
              const Spacer(),
              const Row(
                children: [
                   Icon(Icons.circle, color: Colors.green, size: 6),
                   SizedBox(width: 4),
                   Text('OPTIMAL LIGHT', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunInfo(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.white38),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white)),
      ],
    );
  }
}
