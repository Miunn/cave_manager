import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        width: 150,
        height: 170,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(value, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w200)),
              Text(title, style: const TextStyle(fontSize: 16), textAlign: TextAlign.end),
            ],
          ),
        ),
      ),
    );
  }
}