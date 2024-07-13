import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottleDetailLine extends StatelessWidget {
  const BottleDetailLine({super.key, required this.leftSideText, required this.rightSideText, this.rightSideTextStyle});

  final String leftSideText;
  final String? rightSideText;
  final TextStyle? rightSideTextStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(leftSideText),
          const Spacer(),
          Visibility(
              visible: rightSideText != null,
              child: Text(rightSideText ?? "", style: rightSideTextStyle)
          ),
        ],
      ),
    );
  }
}
