import 'package:flutter/material.dart';

import '../settings.dart';

class PickUpQuiz extends StatefulWidget {
  const PickUpQuiz({super.key});

  @override
  State<PickUpQuiz> createState() => _PickUpQuizState();
}

class _PickUpQuizState extends State<PickUpQuiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Choisir une bouteille"),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const Settings(title: "Paramètres")),
              ),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Column(
          children: <Widget>[
            const Text("Chercher une nouvelle bouteille à sortir")
          ],
        ),
      ),
    );
  }
}