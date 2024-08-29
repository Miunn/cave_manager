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
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    testWidgets('Display bottle details', (WidgetTester tester) async {
      const testKey = Key('bottle_details');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(
          child: LocalizationsInjector(
              child: BottleDetails(key: testKey, bottleId: 0))));

      expect(find.byKey(testKey), findsAny);
    });
  });

  group('Test components', () {
    testWidgets('Test bottle card without data', (WidgetTester tester) async {
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

    testWidgets('Test bottle card with bottle outside of cellar', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderInjector(child: LocalizationsInjector(child: BottleCard(bottle: Bottle(
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

    testWidgets('Test bottle card with bottle inside of cellar', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderInjector(child: LocalizationsInjector(child: BottleCard(bottle: Bottle(
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

    testWidgets('Test bottle card with opened bottle', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderInjector(child: LocalizationsInjector(child: BottleCard(bottle: Bottle(
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
}
