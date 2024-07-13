// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:io';

import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cave_manager/main.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {

  setUpAll(() {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
    }

    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Display home page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChangeNotifierProvider<BottlesProvider>.value(
        value: BottlesProvider(),
        child: const MyApp()
    ));

    // Verify that our counter starts at 0.
    expect(find.text('Home'), findsAny);
  });
}
