import 'package:flutter/material.dart';

import '../models/bottle.dart';

class CellarPin extends StatelessWidget {
  const CellarPin({super.key, this.bottle, required this.onTap});

  final Bottle? bottle;
  final void Function()? onTap;

  Color getBottleColor() {
    if (bottle == null) {
      return Colors.transparent;
    }

    switch (bottle!.color) {
      case "red":
        return Colors.red;
      case "pink":
        return Colors.pink;
      case "white":
        return const Color.fromARGB(255, 220, 220, 220);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(
        side: BorderSide(
          color: Colors.black,
          width: 1,
        ),
      ),
      onTap: () {
        if (onTap == null) {
          return;
        }

        onTap!();
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: getBottleColor(),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }
}
