// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:io';

import 'package:cave_manager/models/bottle.dart';
import 'package:cave_manager/models/enum_wine_colors.dart';
import 'package:cave_manager/screens/add_bottle_dialog.dart';
import 'package:cave_manager/screens/bottle_details.dart';
import 'package:cave_manager/screens/top_screens/bottles.dart';
import 'package:cave_manager/screens/top_screens/cellar.dart';
import 'package:cave_manager/screens/top_screens/home.dart';
import 'package:cave_manager/screens/top_screens/statistics.dart';
import 'package:cave_manager/screens/top_screens/take_out_quiz.dart';
import 'package:cave_manager/widgets/bottle_card.dart';
import 'package:cave_manager/widgets/cellar_layout.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'injectors/LocalizationsInjector.dart';
import 'injectors/ProviderInjector.dart';

void main() {
  setUpAll(() {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
    }

    databaseFactory = databaseFactoryFfi;
  });

  group('Test display top screens', () {
    testWidgets('Display home page', (WidgetTester tester) async {
      const testKey = Key('home');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(
          child: LocalizationsInjector(child: Home(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });

    testWidgets('Display bottles page', (WidgetTester tester) async {
      const testKey = Key('bottles');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(
          child: LocalizationsInjector(child: Bottles(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });

    testWidgets('Display cellar page', (WidgetTester tester) async {
      const testKey = Key('cellar');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(
          child: LocalizationsInjector(child: Cellar(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });

    testWidgets('Display statistics page', (WidgetTester tester) async {
      const testKey = Key('statistics');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(
          child: LocalizationsInjector(child: Statistics(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });

    testWidgets('Display quiz page', (WidgetTester tester) async {
      const testKey = Key('choose');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(
          child: LocalizationsInjector(child: TakeOutQuiz(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });
  });

  group('Test add bottle dialog', () {
    testWidgets('Display add bottle dialog', (WidgetTester tester) async {
      const testKey = Key('add_bottle');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(
          child: LocalizationsInjector(child: AddBottleDialog(key: testKey))));

      expect(find.byKey(testKey), findsAny);
      expect(find.byType(SegmentedButton<WineColors>), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(7));
    });
  });

  group('Test display bottle details', () {
    testWidgets('Pump widget', (WidgetTester tester) async {
      const testKey = Key('bottle_details');

      // Build our app and trigger a frame.
      await tester.pumpWidget(ProviderInjector(
          child: LocalizationsInjector(
              child: BottleDetails(
                  key: testKey,
                  bottle: Bottle.empty(),
                  isCellarConfigured: false))));

      expect(find.byKey(testKey), findsAny);
    });

    testWidgets('Without data, without cellar', (WidgetTester tester) async {
      const testKey = Key('bottle_details');

      // Build our app and trigger a frame.
      await tester.pumpWidget(ProviderInjector(
          child: LocalizationsInjector(
              child: BottleDetails(
                  key: testKey,
                  bottle: Bottle.empty(),
                  isCellarConfigured: false))));

      expect(find.byKey(testKey), findsAny);
      expect(find.text('No name'), findsNWidgets(2));
      expect(find.text('No estate'), findsOneWidget);
      expect(find.text('No vintage'), findsOneWidget);
      expect(find.text('Color'), findsOneWidget);
      expect(find.text('Alcohol level'), findsOneWidget);
      expect(find.text('Grape'), findsOneWidget);
      expect(find.text('Bottle created at'), findsOneWidget);
      expect(find.text('Country'), findsOneWidget);
      expect(find.text('Region'), findsOneWidget);
      expect(find.text('Sub region'), findsOneWidget);

      expect(find.text('Unknown'), findsNWidgets(7));
      expect(find.text('Configure your cellar to register this bottle'), findsOneWidget);

      expect(find.byType(OutlinedButton), findsNothing);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('Without data, with cellar', (WidgetTester tester) async {
      const testKey = Key('bottle_details');

      // Build our app and trigger a frame.
      await tester.pumpWidget(ProviderInjector(
          child: LocalizationsInjector(
              child: BottleDetails(
                  key: testKey,
                  bottle: Bottle.empty(),
                  isCellarConfigured: true))));

      expect(find.byKey(testKey), findsAny);
      expect(find.text('No name'), findsNWidgets(2));
      expect(find.text('No estate'), findsOneWidget);
      expect(find.text('No vintage'), findsOneWidget);
      expect(find.text('Color'), findsOneWidget);
      expect(find.text('Alcohol level'), findsOneWidget);
      expect(find.text('Grape'), findsOneWidget);
      expect(find.text('Bottle created at'), findsOneWidget);
      expect(find.text('Country'), findsOneWidget);
      expect(find.text('Region'), findsOneWidget);
      expect(find.text('Sub region'), findsOneWidget);

      expect(find.text('Unknown'), findsNWidgets(7));
      expect(find.text('This bottle is not in the cellar'), findsOneWidget);

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('With data', (WidgetTester tester) async {
      Country country = Country.parse('fr');
      await tester.pumpWidget(ProviderInjector(child: LocalizationsInjector(child: BottleDetails(bottle: Bottle(
        'name',
        DateTime.now(),
        false,
        signature: 'estate',
        color: WineColors.red.value,
        alcoholLevel: 12.5,
        grapeVariety: 'grape',
        country: country.countryCode,
        area: 'region',
        subArea: 'sub region',
        vintageYear: 1990,
      ), isCellarConfigured: true))));

      expect(find.text('name'), findsNWidgets(2));
      expect(find.text('estate'), findsOneWidget);
      expect(find.text('1990'), findsOneWidget);
      expect(find.text('Red'), findsOneWidget);
      expect(find.text('12.5 %'), findsOneWidget);
      expect(find.text('grape'), findsOneWidget);
      expect(find.text(DateFormat.yMMMd().format(DateTime.now())), findsOneWidget);
      expect(find.text("${country.flagEmoji} ${country.name}"), findsOneWidget);
      expect(find.text('region'), findsOneWidget);
      expect(find.text('sub region'), findsOneWidget);
    });
  });

  group('Test bottle card', () {
    testWidgets('Without data', (WidgetTester tester) async {
      const testKey = Key('bottle_card');

      // Build our app and trigger a frame.
      await tester.pumpWidget(ProviderInjector(
          child: LocalizationsInjector(
              child: BottleCard(key: testKey, bottle: Bottle.empty()))));

      expect(find.byKey(testKey), findsAny);
      expect(find.text('See in cellar'), findsNothing);
      expect(find.text('Take out bottle'), findsNothing);
      expect(find.text('Place in cellar'), findsNothing);
      expect(find.text('Open bottle'), findsNothing);
    });

    testWidgets('With bottle outside of cellar', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderInjector(
          child: LocalizationsInjector(
              child: BottleCard(
                  bottle: Bottle(
        'name',
        DateTime.now(),
        false,
        color: WineColors.red.value,
        isInCellar: false,
      )))));

      expect(find.text('See in cellar'), findsNothing);
      expect(find.text('Take out bottle'), findsNothing);
      expect(find.text('Place in cellar'), findsOneWidget);
      expect(find.text('Open bottle'), findsOneWidget);
    });

    testWidgets('With bottle inside of cellar', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderInjector(
          child: LocalizationsInjector(
              child: BottleCard(
                  bottle: Bottle(
        'name',
        DateTime.now(),
        false,
        color: WineColors.red.value,
        clusterId: 0,
        clusterX: 0,
        clusterY: 0,
        isInCellar: true,
      )))));

      expect(find.text('See in cellar'), findsOneWidget);
      expect(find.text('Take out bottle'), findsOneWidget);
      expect(find.text('Place in cellar'), findsNothing);
      expect(find.text('Open bottle'), findsNothing);
    });

    testWidgets('With opened bottle', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderInjector(
          child: LocalizationsInjector(
              child: BottleCard(
                  bottle: Bottle(
        'name',
        DateTime.now(),
        true,
        color: WineColors.red.value,
      )))));

      expect(find.text('See in cellar'), findsNothing);
      expect(find.text('Take out bottle'), findsNothing);
      expect(find.text('Place in cellar'), findsNothing);
      expect(find.text('Open bottle'), findsNothing);
    });
  });

  group('Test cellar layout', () {
    testWidgets('Pump no clusters cellar', (WidgetTester tester) async {
      const testKey = Key('cellar');

      // Build our app and trigger a frame.
      await tester.pumpWidget(
          ProviderInjector(
              child: LocalizationsInjector(
                  child: CellarLayout(key: testKey)
              )
          )
      );

      expect(find.byKey(testKey), findsAny);
    });
  });
}
