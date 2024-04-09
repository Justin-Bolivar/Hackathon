import 'package:flutter/material.dart';

class WriteJournalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Journal Page'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'April 9',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const Text(
            '10 AM',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              maxLines: 10,
              expands: false,
              decoration: InputDecoration(
                hintText: 'Start your Journal.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
