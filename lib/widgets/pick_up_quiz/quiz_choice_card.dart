import 'package:flutter/material.dart';

class QuizChoiceCard extends StatelessWidget {
  const QuizChoiceCard({super.key, required this.onTap, required this.icon, required this.label});

  final void Function() onTap;
  final Icon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 140,
          height: 140,
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(children: <Widget>[
              SizedBox(
                height: 60,
                child: icon,
              ),
              Text(label),
            ]),
          ),
        ),
      ),
    );
  }
}