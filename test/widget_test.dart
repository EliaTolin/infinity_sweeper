// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:infinity_sweeper/main.dart';
import 'package:infinity_sweeper/models/cell/cell_model.dart';
import 'package:infinity_sweeper/widgets/game/cell_widget.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const InfinitySweeper());

    // Verify that our counter starts at 0.
    expect(find.text('easy'), findsOneWidget);
    await tester.pump();
    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byWidget(CellWidget(CellModel(4,4),20, 20)));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('1'), findsWidgets);
  });
}
