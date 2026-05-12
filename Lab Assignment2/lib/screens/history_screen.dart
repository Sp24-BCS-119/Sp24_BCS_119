import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final data = await DatabaseHelper().getHistory();
    setState(() => _history = data);
  }

  void _clearHistory() async {
    await DatabaseHelper().clearHistory();
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearHistory,
          ),
        ],
      ),
      body: _history.isEmpty
          ? const Center(child: Text('No games played yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                final bool isCorrect = item['status'] == 'correct';
                final Color color = isCorrect ? Colors.green : (item['status'] == 'too high' ? Colors.orange : Colors.blue);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      child: Text(
                        '${item['guess']}',
                        style: TextStyle(color: color, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      item['status'].toString().toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Target: ${item['target']}'),
                    trailing: Text(
                      DateFormat('HH:mm').format(DateTime.parse(item['timestamp'])),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
