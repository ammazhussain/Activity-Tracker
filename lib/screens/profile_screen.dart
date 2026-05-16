import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _age = '';
  String _weight = '';
  String _height = '';
  String _goal = '';
  String _email = '';
  String? _avatarPath;
  List<Map<String, dynamic>> _activities = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_profile');
    final activityList = prefs.getStringList('activities') ?? [];
    _avatarPath = prefs.getString('user_avatar_path');

    if (userData != null) {
      final data = jsonDecode(userData);
      setState(() {
        _name = data['name'];
        _age = data['age'];
        _weight = data['weight'];
        _height = data['height'];
        _goal = data['goal'];
        _email = data['email'];
      });
    }

    setState(() {
      _activities =
          activityList
              .map((e) => jsonDecode(e) as Map<String, dynamic>)
              .toList();
    });
  }

  Future<void> _choosePresetAvatar() async {
    final avatars = [
      'assets/avatars/dumbbell.png',
      'assets/avatars/barbell.png',
      'assets/avatars/yoga.png',
      'assets/avatars/runner.png',
      'assets/avatars/boxing.png',
      'assets/avatars/trainer.png',
    ];

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Choose an Avatar'),
            content: SizedBox(
              width: double.maxFinite,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: avatars.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('user_avatar_path', avatars[i]);
                      setState(() {
                        _avatarPath = avatars[i];
                      });
                      Navigator.pop(context);
                    },
                    child: Image.asset(avatars[i]),
                  );
                },
              ),
            ),
          ),
    );
  }

  Future<void> _deleteActivity(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _activities.removeAt(index);
    final updated = _activities.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('activities', updated);
    setState(() {});
  }

  Future<void> _markActivityDone(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = prefs.getStringList('history_activities') ?? [];

    final completed = jsonEncode(_activities[index]);
    historyList.add(completed);
    await prefs.setStringList('history_activities', historyList);

    await _deleteActivity(index);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
          title: Row(
            children: [
              Image.asset('assets/runner.png', width: 30),
              const SizedBox(width: 10),
              const Text('Profile'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _choosePresetAvatar,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            _avatarPath != null
                                ? AssetImage(_avatarPath!)
                                : null,
                        child:
                            _avatarPath == null
                                ? const Icon(Icons.person, size: 40)
                                : null,
                      ),
                      const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(_name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(_email),
                const Divider(height: 32),
                const Text(
                  'Personal Info',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _infoRow('Age', _age),
                _infoRow('Weight', _weight),
                _infoRow('Height', _height),
                _infoRow('Goal', _goal),
                const SizedBox(height: 20),
                const Text(
                  'Tracked Activities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (_activities.isEmpty)
                  const Text(
                    'No activity selected yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                for (int i = 0; i < _activities.length; i++)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        '${_activities[i]['title']} (${_activities[i]['env']})',
                      ),
                      subtitle: Text(
                        '${_activities[i]['distance']} ${_activities[i]['unit']} @ ${_activities[i]['time']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            tooltip: 'Mark as done',
                            onPressed: () => _markActivityDone(i),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Delete',
                            onPressed: () => _deleteActivity(i),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
