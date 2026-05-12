import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'dart:math';

class GuessScreen extends StatefulWidget {
  const GuessScreen({super.key});

  @override
  State<GuessScreen> createState() => _GuessScreenState();
}

class _GuessScreenState extends State<GuessScreen> {
  final TextEditingController _controller = TextEditingController();
  int _targetNumber = Random().nextInt(100) + 1;
  String? _errorText;

  void _generateNewTarget() {
    setState(() {
      _targetNumber = Random().nextInt(100) + 1;
      _controller.clear();
      _errorText = null;
    });
  }

  void _checkGuess() async {
    final int? guess = int.tryParse(_controller.text);
    if (guess == null || guess < 1 || guess > 100) {
      setState(() => _errorText = 'Please enter a number between 1-100');
      return;
    }

    String status = '';
    if (guess == _targetNumber) status = 'correct';
    else if (guess > _targetNumber) status = 'too high';
    else status = 'too low';

    await DatabaseHelper().insertResult(guess, _targetNumber, status);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          guess: guess,
          status: status,
          onNewGame: _generateNewTarget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess & Win'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology, size: 80, color: Color(0xFF5855F2)),
            const SizedBox(height: 24),
            const Text(
              "I'm thinking of a number...",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Can you guess it? (1-100)'),
            const SizedBox(height: 40),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '?',
                errorText: _errorText,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _checkGuess,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5855F2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Check My Guess', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
