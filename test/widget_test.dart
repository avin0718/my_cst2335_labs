import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:lab2/localization/app_localizations.dart';
import 'package:lab2/main.dart';
import 'package:lab2/pages/list_page.dart';
import 'package:lab2/pages/login_page.dart';
import 'package:lab2/pages/profile_page.dart';
import 'package:lab2/repository/profile_repository.dart';
import 'package:lab2/widgets/details_widget.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    AppLocalizations.currentLanguage = 'en';
  });

  testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    final repository = ProfileRepository();

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('LoginPage shows stop sign image on incorrect password',
      (WidgetTester tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    final repository = ProfileRepository();

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pumpAndSettle();

    // Enter username and WRONG password
    await tester.enterText(find.byType(TextFormField).at(0), 'TestUser');
    await tester.enterText(find.byType(TextFormField).at(1), 'WRONG_PASSWORD');

    // Tap Login button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify AlertDialog does NOT appear and SnackBar error shows
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Invalid password!'), findsOneWidget);
  });

  testWidgets('LoginPage shows AlertDialog and navigates on correct password ASDF',
      (WidgetTester tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    final repository = ProfileRepository();

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pumpAndSettle();

    // Enter username and CORRECT password ASDF
    await tester.enterText(find.byType(TextFormField).at(0), 'TestUser');
    await tester.enterText(find.byType(TextFormField).at(1), 'ASDF');

    // Tap Login button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify AlertDialog appears with Yes/No buttons
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);

    // Tap Yes on AlertDialog
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    // Verify Navigation to ProfilePage
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Welcome Back TestUser'), findsNWidgets(2));
  });

  testWidgets('ListPage adds contact, opens details on tap, and deletes via DetailsWidget',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: ListPage(),
      ),
    );

    await tester.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 200));
    });
    await tester.pumpAndSettle();

    // Fill in text fields
    await tester.enterText(find.byType(TextField).at(0), 'Eric');
    await tester.enterText(find.byType(TextField).at(1), 'Torunski');
    await tester.enterText(find.byType(TextField).at(2), '613 123-4567');
    await tester.enterText(find.byType(TextField).at(3), 'torunse@algonquincollege.com');

    // Tap Submit button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));

    await tester.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 200));
    });
    await tester.pumpAndSettle();

    // Verify contact appears in list
    expect(find.text('Eric Torunski'), findsOneWidget);

    // Tap gesture on contact item to view Details
    await tester.tap(find.text('Eric Torunski'));
    await tester.pumpAndSettle();

    // Verify DetailsWidget is displayed with Item Name and Database ID
    expect(find.byType(DetailsWidget), findsOneWidget);
    expect(find.text('Item Details'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Delete'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Close'), findsOneWidget);

    // Tap Delete button on Details page
    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'), warnIfMissed: false);
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      await Future.delayed(const Duration(milliseconds: 200));
    });
    await tester.pumpAndSettle();

    // Verify contact is deleted and details widget is closed
    expect(find.text('Eric Torunski'), findsNothing);
  });
}
