import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_screen.dart';
import 'choose_activity_page.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  double runningTotal = 0;
  double cyclingTotal = 0;
  double swimmingTotal = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  Future<void> _calculateTotals() async {
    final prefs = await SharedPreferences.getInstance();
    final doneActivities = prefs.getStringList('done_activities') ?? [];

    double run = 0, cycle = 0, swim = 0;
    for (final item in doneActivities) {
      final data = jsonDecode(item);

      // Ensure proper parsing
      final double distance =
          (data['distance'] is int)
              ? (data['distance'] as int).toDouble()
              : (data['distance'] ?? 0.0);

      final String type = data['title'] ?? '';

      // Combine walking and running into 'Running'
      if (type == 'Running' || type == 'Walking') {
        run += distance;
      } else if (type == 'Cycling') {
        cycle += distance;
      } else if (type == 'Swimming') {
        swim += distance;
      }
    }

    setState(() {
      runningTotal = run;
      cyclingTotal = cycle;
      swimmingTotal = swim;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _Dashboard(
        runningTotal: runningTotal,
        cyclingTotal: cyclingTotal,
        swimmingTotal: swimmingTotal,
      ),
      const SizedBox(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: _index == 2 ? null : AppBar(automaticallyImplyLeading: false),
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index > 1 ? 2 : _index,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 32),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _onItemTapped(int i) async {
    if (i == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChooseActivityPage()),
      );
      _calculateTotals();
    } else if (i == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
      _calculateTotals();
    }
    setState(() => _index = i);
  }
}

class _Dashboard extends StatelessWidget {
  final double runningTotal;
  final double cyclingTotal;
  final double swimmingTotal;

  const _Dashboard({
    required this.runningTotal,
    required this.cyclingTotal,
    required this.swimmingTotal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/runner.png', width: 40),
              const SizedBox(width: 10),
              Text(
                'Activity Tracker',
                style: theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/dashboard.png',
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _StatCard(
                title: 'Running',
                points: '${runningTotal.toStringAsFixed(1)} km',
              ),
              const SizedBox(width: 12),
              _StatCard(
                title: 'Cycling',
                points: '${cyclingTotal.toStringAsFixed(1)} km',
              ),
              const SizedBox(width: 12),
              _StatCard(
                title: 'Swimming',
                points: '${swimmingTotal.toStringAsFixed(1)} km',
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChooseActivityPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Activity'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.green.shade700, width: 2),
                    foregroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen()),
                    );
                  },
                  child: const Text('History'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String points;

  const _StatCard({required this.title, required this.points});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              points,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
