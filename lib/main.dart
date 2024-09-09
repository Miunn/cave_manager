import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:cave_manager/providers/history_provider.dart';
import 'package:cave_manager/screens/add_bottle_dialog.dart';
import 'package:cave_manager/screens/top_screens/bottles.dart';
import 'package:cave_manager/screens/top_screens/cellar.dart';
import 'package:cave_manager/screens/top_screens/home.dart';
import 'package:cave_manager/screens/top_screens/take_out_quiz.dart';
import 'package:cave_manager/screens/top_screens/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }

  databaseFactory = databaseFactoryFfi;

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => BottlesProvider()),
    ChangeNotifierProvider(create: (context) => ClustersProvider()),
    ChangeNotifierProvider(create: (context) => HistoryProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cave Manager',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
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
      home: const MyHomePage(title: "Accueil"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

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
        const Home(),
        const Bottles(),
        const Cellar(),
        const Statistics(),
        const TakeOutQuiz(),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.home),
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.home,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.wine_bar),
            icon: const Icon(Icons.wine_bar_outlined),
            label: AppLocalizations.of(context)!.bottles,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.storefront),
            icon: const Icon(Icons.storefront_outlined),
            label: AppLocalizations.of(context)!.cellar,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.show_chart),
            icon: const Icon(Icons.show_chart),
            label: AppLocalizations.of(context)!.statistics,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.quiz),
            icon: const Icon(Icons.quiz_outlined),
            label: AppLocalizations.of(context)!.choose,
          ),
        ],
      ),
      floatingActionButton: (currentPageIndex != 2 && currentPageIndex != 4)
          ? OpenContainer(
              closedElevation: 6,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              transitionDuration: const Duration(milliseconds: 400),
              closedBuilder: (BuildContext context, VoidCallback action) =>
                  FloatingActionButton(
                onPressed: () {
                  /*Navigator.of(context).push(MaterialPageRoute<Bottle>(
                fullscreenDialog: true,
                builder: (BuildContext context) => const AddBottleDialog()));*/
                  action();
                },
                tooltip: AppLocalizations.of(context)!.insertBottle,
                child: const Icon(Icons.add),
              ),
              openBuilder: (BuildContext context, VoidCallback action) =>
                  const AddBottleDialog(),
              tappable: false,
            )
          : null,
    );
  }
}
