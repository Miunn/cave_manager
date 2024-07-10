import 'package:cave_manager/widgets/Ring/animated_semi_ring.dart';
import 'package:flutter/cupertino.dart';

class CellarFillingShort extends StatefulWidget {
  const CellarFillingShort({super.key, required this.bottleAmount, this.text = ""});

  final int bottleAmount;
  final String text;

  @override
  State<StatefulWidget> createState() => _CellarFillingShortState();
}

class _CellarFillingShortState extends State<CellarFillingShort> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 170,
      child: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                AnimatedSemiRing(
                  color: const Color.fromARGB(100, 0, 200, 0),
                  radius: 45,
                  fillPercentage: widget.bottleAmount / 50 * 100,
                  strokeWidth: 15,
                ),
                Text(
                  "${widget.bottleAmount}",
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
