import 'package:cave_manager/widgets/Ring/animated_ring.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CellarFilling extends StatefulWidget {
  const CellarFilling({super.key, required this.bottleAmount});

  final int bottleAmount;

  @override
  State<StatefulWidget> createState() => _CellarFillingState();
}

class _CellarFillingState extends State<CellarFilling> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
         Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedRing(
              color: const Color.fromARGB(100, 0, 200, 0),
              radius: 45,
              fillPercentage: widget.bottleAmount/50 * 100,
              strokeWidth: 15,
            ),
            Text("${widget.bottleAmount}", style: const TextStyle(fontSize: 30)),
          ],
        ),
        const SizedBox(width: 20,),
        Text(AppLocalizations.of(context)!.bottlesTotal(widget.bottleAmount),
          style: const TextStyle(fontSize: 30),
        ),
      ],
    );
  }

}