import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/screens/bottles.dart';
import 'package:cave_manager/screens/cellar.dart';
import 'package:cave_manager/screens/home.dart';
import 'package:cave_manager/screens/settings.dart';
import 'package:cave_manager/screens/statistics.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cave Manager',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Accueil'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: <Widget>[
        const Home(title: "Accueil"),
        const Bottles(title: "Mes bouteilles"),
        const Cellar(title: "Ma cave"),
        const Statistics(title: "Statistiques"),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            switch (index) {
              case 0:
                {
                  widget.title = 'Accueil';
                }
                break;
              case 1:
                {
                  widget.title = 'Mes bouteilles';
                }
                break;
              case 2:
                {
                  widget.title = 'Ma cave';
                }
                break;
              case 3:
                {
                  widget.title = 'Statistiques';
                }
                break;
            }
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.wine_bar),
            icon: Icon(Icons.wine_bar_outlined),
            label: 'Bouteilles',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.storefront),
            icon: Icon(Icons.storefront_outlined),
            label: 'Cave',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.show_chart),
            icon: Icon(Icons.show_chart),
            label: 'Statistiques',
          ),
        ],
      ),
    );
  }
}
