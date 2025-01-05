import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:muday/src/models/db.dart';
import 'package:muday/src/utils/background_service.dart';

// import 'package:muday/src/utils/sms_parsers.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  print('Settings loaded!');

  WidgetsFlutterBinding.ensureInitialized();

  // Run background service
  await initializeService();

  // // create a database
  final db = DatabaseService.instance;
  // print('Database initialized: $db');
  // print('Database getTables: ${await db.getTables()}');

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController, db: db));
}
