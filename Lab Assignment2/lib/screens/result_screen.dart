import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int guess;
  final String status;
  final VoidCallback onNewGame;

  const ResultScreen({
    super.key,
    required this.guess,
    required this.status,
    required this.onNewGame,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = status == 'correct';
    final Color color = isCorrect ? Colors.green : (status == 'too high' ? Colors.orange : Colors.blue);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.emoji_events : (status == 'too high' ? Icons.arrow_upward : Icons.arrow_downward),
                  size: 80,
                  color: color,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Your guess: $guess',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Text(
                status.toUpperCase(),
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.black, color: color),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (isCorrect) onNewGame();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5855F2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(isCorrect ? 'New Game' : 'Try Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
