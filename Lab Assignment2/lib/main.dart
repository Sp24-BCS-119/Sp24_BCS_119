import 'package:flutter/material.dart';
import 'screens/guess_screen.dart';

void main() {
  runApp(const NumberGuessApp());
}

class NumberGuessApp extends StatelessWidget {
  const NumberGuessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NumGuess Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5855F2),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF05081A),
        fontFamily: 'Jakarta',
      ),
      home: const GuessScreen(),
    );
  }
}
