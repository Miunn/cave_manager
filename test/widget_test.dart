// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:io';

import 'package:cave_manager/screens/top_screens/bottles.dart';
import 'package:cave_manager/screens/top_screens/cellar.dart';
import 'package:cave_manager/screens/top_screens/home.dart';
import 'package:cave_manager/screens/top_screens/statistics.dart';
import 'package:cave_manager/screens/top_screens/take_out_quiz.dart';
import 'package:flutter/cupertino.dart';
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
      await tester.pumpWidget(const ProviderInjector(child: LocalizationsInjector(child: Home(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });
    
    testWidgets('Display bottles page', (WidgetTester tester) async {
      const testKey = Key('bottles');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(child: LocalizationsInjector(child: Bottles(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });

    testWidgets('Display cellar page', (WidgetTester tester) async {
      const testKey = Key('cellar');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(child: LocalizationsInjector(child: Cellar(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });

    testWidgets('Display statistics page', (WidgetTester tester) async {
      const testKey = Key('statistics');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(child: LocalizationsInjector(child: Statistics(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });

    testWidgets('Display quiz page', (WidgetTester tester) async {
      const testKey = Key('choose');

      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderInjector(child: LocalizationsInjector(child: TakeOutQuiz(key: testKey))));

      expect(find.byKey(testKey), findsAny);
    });
  });
}
