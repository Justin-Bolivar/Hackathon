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
      backgroundColor: const Color(0xFFFFFBF0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 300,
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Color(0xFFFFFBF0)),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF8FA247),
                  labelText: 'IP and Port Number',
                  labelStyle: TextStyle(
                    color: Color(0xFFFFFBF0),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changeIP,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFFFFFBF0),
                backgroundColor: const Color(0xFF647131),
              ),
              child: const Text('Set'),
            ),
          ],
        ),
      ),
    );
  }
}
