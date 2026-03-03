import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const DiceGameApp());
}

class DiceGameApp extends StatelessWidget {
  const DiceGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiceGameScreen(),
    );
  }
}

class DiceGameScreen extends StatefulWidget {
  const DiceGameScreen({super.key});

  @override
  State<DiceGameScreen> createState() => _DiceGameScreenState();
}

class _DiceGameScreenState extends State<DiceGameScreen>
    with TickerProviderStateMixin {
  final Random random = Random();

  late AnimationController _rotateController;
  late AnimationController _scaleController;

  late Animation<double> _rotation;
  late Animation<double> _scale;

  int diceNumber = 1;
  int score = 0;
  List<String> history = [];

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _rotation = Tween(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeOut),
    );

    _scale = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  void rollDice(int guess) async {
    _rotateController.forward(from: 0);
    _scaleController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      diceNumber = random.nextInt(6) + 1;

      if (guess == diceNumber) {
        score += 10;
        history.insert(0, "Win 🎉 | Guess: $guess | Dice: $diceNumber");
        showResultDialog(true);
      } else {
        history.insert(0, "Lose ❌ | Guess: $guess | Dice: $diceNumber");
        showResultDialog(false);
      }

      if (history.length > 5) {
        history.removeLast();
      }
    });

    _scaleController.reverse();
  }

  void showResultDialog(bool isWin) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isWin ? "You Won! 🎉" : "You Lost 😢",
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          "Dice number was $diceNumber",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  void pickNumber() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return SizedBox(
          height: 150,
          child: GridView.count(
            crossAxisCount: 6,
            padding: const EdgeInsets.all(20),
            children: List.generate(6, (index) {
              int num = index + 1;
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  rollDice(num);
                },
                child: Card(
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "$num",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      history.clear();
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎲  Dice Roll App"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.blue]),
          ),
        ),
      ),
      backgroundColor: const Color(0xff121212),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Score: $score",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            AnimatedBuilder(
              animation: _rotateController,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _rotation.value,
                  child: ScaleTransition(scale: _scale, child: child),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blueAccent,
                      blurRadius: 30,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Image.asset("assets/images/$diceNumber.png", width: 130),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: pickNumber,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Roll Dice", style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Reset Game"),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Activity",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (_, index) {
                  return Card(
                    color: Colors.grey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        history[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
