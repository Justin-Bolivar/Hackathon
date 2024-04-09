import 'package:flutter/material.dart';
import 'globals.dart'; // Import the globals file

class Settings extends StatelessWidget {
  Settings({super.key});
  final TextEditingController _controller = TextEditingController();

  void _changeIP() {
    Globals.ipAddress = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF332d41),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Color(0xFFd2c0ff)),
        ),
        backgroundColor: const Color(0xFF332d41),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Color(0xFFd2c0ff)),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF1e192b),
                  labelText: 'IP and Port Number',
                  labelStyle: TextStyle(color: Color(0xFFd2c0ff)),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changeIP,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFFd2c0ff),
                backgroundColor: const Color(0xFF4f378a),
              ),
              child: const Text('Set'),
            ),
          ],
        ),
      ),
    );
  }
}
