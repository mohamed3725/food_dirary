import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/widgets/custom_text_field.dart';
import 'package:food_diary/widgets/primary_button.dart';

void main() {
  testWidgets('CustomTextField shows label and accepts input',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomTextField(label: 'Email', controller: controller),
      ),
    ));

    expect(find.text('Email'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'hello@example.com');
    expect(controller.text, 'hello@example.com');
  });

  testWidgets('PrimaryButton shows text and loading state',
      (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PrimaryButton(
            text: 'Press',
            onPressed: () {
              pressed = true;
            }),
      ),
    ));

    expect(find.text('Press'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    expect(pressed, isTrue);
  });
}
