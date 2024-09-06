import 'package:cave_manager/widgets/pick_up_quiz/quiz_choice_card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../appBarNavigation/history.dart';
import '../appBarNavigation/settings.dart';

class TakeOutQuiz extends StatefulWidget {
  const TakeOutQuiz({super.key});

  @override
  State<TakeOutQuiz> createState() => _TakeOutQuizState();
}

class _TakeOutQuizState extends State<TakeOutQuiz> {
  int matchingBottles = 0;

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
                      builder: (context) => const CellarHistory()
                  )
              ),
              icon: const Icon(Icons.history)),
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
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  QuizChoiceCard(
                    onTap: () {},
                    icon: Icon(MdiIcons.foodSteak),
                    label: "Viande",
                  ),
                  QuizChoiceCard(
                    onTap: () {},
                    icon: Icon(MdiIcons.fish),
                    label: "Poisson",
                  )
                ],
              ),
              Text("$matchingBottles bouteilles correspondantes", style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
