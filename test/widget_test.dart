import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:popcorn1/Screens/login_screen.dart';
import 'package:popcorn1/Screens/register_screen.dart';
import 'package:popcorn1/Screens/start_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {

    testWidgets('Login Failure Snackbar Shown', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Both email and password are required.'), findsOneWidget);
    });

    
  });

  group('RegisterScreen Widget Tests', () {
    testWidgets('UI Renders Correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterScreen()));

      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Already registered?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Registration Failure Shows Snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterScreen()));

      final registerButton = find.text('Register');
      await tester.tap(registerButton);
      await tester.pump();

      expect(find.text('Both email and password are required.'), findsOneWidget);
    });

    testWidgets('Passwords Match', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterScreen()));

      await tester.enterText(find.byType(TextField).first, 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.enterText(find.byType(TextField).last, 'password123');

      final registerButton = find.text('Register');
      await tester.tap(registerButton);
      await tester.pump();

      // Ensure that the snackbar is not shown since passwords match
      expect(find.text("Passwords don't match"), findsNothing);
    });

    // Add more test cases for different scenarios as needed
  });

  group('StartupScreen Widget Tests', () {
    testWidgets('UI Renders Correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: StartupScreen()));

      expect(find.text('Welcome to Popcorn: Your Gateway to Cinematic Exploration!\n\nEmbark on an immersive journey into the captivating world of cinema with Popcorn, your ultimate movie companion. As the startup screen greets you, prepare to delve into a realm where movie magic knows no bounds.'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('Navigation to Login Screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: StartupScreen()));

      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Ensure that the navigation takes the user to LoginScreen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Navigation to Register Screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: StartupScreen()));

      final registerButton = find.text('Register');
      await tester.tap(registerButton);
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Ensure that the navigation takes the user to RegisterScreen
      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });
}
