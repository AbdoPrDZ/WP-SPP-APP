// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spp_webview/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

// import '../lib/src/utilsvalidator.dart';

// void validate(String text, String rules, String attribute) {
//   final resault = text.validate(rules, attribute);
//   print(
//     "validate '$text' with $rules: ${resault.firstOrNull}",
//   );
// }

// void main() {
//   validate("", "required", "text");
//   // Output: validate '' with required: The text field is required
//   validate("user", "required|email", "email");
//   // Output: validate 'user' with required|email: The email field must be a valid email
//   validate("user@mail.com", "required|email", "email");
//   // Output: validate 'user@mail.com' with required|email: null
//   validate("12", "required|password", "password");
//   // Output: validate '12' with required|password: The password field must be at least 6 characters
//   validate("123456", "required|password", "password");
//   // Output: validate '123456' with required|password: null
//   validate("123", "min:4", "text");
//   // Output: validate '123' with min:4: The text field must be at least 4 characters
//   validate("3", "min:4,number", "number");
//   // Output: validate '3' with min:4: The number field must be at least 4
//   validate("123456", "max:4", "text");
//   // Output: validate '123456' with max:4: The text field may not be greater than 4 characters
//   validate("8", "max:4,number", "number");
//   // Output: validate '8' with max:4: The number field may not be greater than
// }
