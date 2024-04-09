import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JournalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal Page'),
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
          Center(
            child: Container(
              height: 400,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
