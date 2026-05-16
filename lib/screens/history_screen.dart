import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('done_activities') ?? [];
    setState(() {
      _history =
          list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/runner.png', width: 30),
            const SizedBox(width: 10),
            const Text('Activity History'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child:
            _history.isEmpty
                ? const Center(child: Text('No completed activities yet.'))
                : ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final act = _history[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text('${act['title']} (${act['env']})'),
                        subtitle: Text(
                          '${act['distance']} ${act['unit']} at ${act['time']}',
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
