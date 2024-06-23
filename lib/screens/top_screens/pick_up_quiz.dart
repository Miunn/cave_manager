import 'package:cave_manager/widgets/pick_up_quiz/quiz_choice_card.dart';
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Plutôt", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QuizChoiceCard(
                    onTap: () {},
                    icon: const Icon(Icons.local_bar),
                    label: "Apéritif",
                  ),
                  QuizChoiceCard(
                    onTap: () {},
                    icon: const Icon(Icons.restaurant),
                    label: "Plat cuisiné",
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
