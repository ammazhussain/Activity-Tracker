import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedGoal = 'Stay Fit';

  Future<void> _saveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileData = jsonEncode({
      'name': _nameController.text.trim(),
      'age': _ageController.text.trim(),
      'weight': _weightController.text.trim(),
      'height': _heightController.text.trim(),
      'goal': _selectedGoal,
      'email': _emailController.text.trim(),
      'password': _passwordController.text, // Save password
    });
    await prefs.setString('user_profile', profileData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step Into Fitness — Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset('assets/runner.png', width: 60),
              ),
              const SizedBox(height: 20),
              Text(
                'Activity Tracker',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoSlab',
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: _dec('Name', Icons.person_outline),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _ageController,
                decoration: _dec('Age', Icons.calendar_today),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _weightController,
                decoration: _dec('Weight (kg)', Icons.monitor_weight),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _heightController,
                decoration: _dec('Height (cm)', Icons.height),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: _dec('Fitness Goal', Icons.flag),
                value: _selectedGoal,
                items: const [
                  DropdownMenuItem(value: 'Stay Fit', child: Text('Stay Fit')),
                  DropdownMenuItem(value: 'Lose Fat', child: Text('Lose Fat')),
                  DropdownMenuItem(value: 'Cardio', child: Text('Cardio')),
                  DropdownMenuItem(
                    value: 'All of the Above',
                    child: Text('All of the Above'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGoal = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: _dec('Email', Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: _dec('Password', Icons.lock_outline),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await _saveUserProfile();
                    Navigator.pop(context);
                  },
                  child: const Text('Register', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String label, IconData icon) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    prefixIcon: Icon(icon),
  );
}
