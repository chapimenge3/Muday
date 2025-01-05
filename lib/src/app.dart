import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muday/src/models/db.dart';
import 'package:muday/src/models/transaction.dart';
import 'package:muday/src/screen/error.dart';
import 'package:muday/src/screen/home/home.dart';
import 'package:muday/src/screen/transactions/transactions_details.dart';
import 'package:muday/src/screen/transactions/transactions_list.dart';
import 'package:permission_handler/permission_handler.dart';

import 'theme.dart';

import 'sample_feature/sample_item_details_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class Routes {
  static const String settings = '/settings';
  static const String sampleItemDetails = '/item-details';
  static const String sampleItemList = '/item-list';
  static const String transactionDetails = '/transaction-details';
  static const String transactionList = '/transaction-list';
}

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.settingsController, required this.db});

  final SettingsController settingsController;
  final DatabaseService db;

  Future<bool> _checkPermissionAndReadSMS() async {
    var permission = await Permission.sms.status;
    if (!permission.isGranted) {
      permission = await Permission.sms.request();
      if (!permission.isGranted) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.

    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          debugShowCheckedModeBanner: false,

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('am', ''), // Amharic, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          // theme: ThemeData(
          //   // colorScheme: ColorScheme.light()
          //   colorScheme: ColorScheme.light(
          //     primary: Color(0xFF36618e),
          //     secondary: Color(0xFF535f70),
          //     tertiary: Color(0xFF6b5778),
          //     error: Color(0xFFba1a1a),
          //   ),
          // ),
          // darkTheme: ThemeData(
          //   colorScheme: ColorScheme.dark(
          //     primary: Color(0xFFa0cafd),
          //     secondary: Color(0xFFbbc7db),
          //     tertiary: Color(0xFFd6bee4),
          //     error: Color(0xFFffb4ab),
          //   ),
          // ),
          theme: materialTheme.light(),
          darkTheme: materialTheme.dark(),
          themeMode: settingsController.themeMode,
          home: FutureBuilder(
            future: _checkPermissionAndReadSMS(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError || snapshot.data == false) {
                return const Scaffold(
                  body: Center(
                    child: Text(
                      'SMS permission is required to use this app',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              return const HomeScreen();
            },
          ),
          // home: const HomeScreen(),

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case Routes.settings:
                    return SettingsView(controller: settingsController);

                  case Routes.sampleItemDetails:
                    return const SampleItemDetailsView();

                  case Routes.transactionDetails:
                    // Extract the transaction from arguments
                    final args =
                        routeSettings.arguments as Map<String, dynamic>?;
                    final transaction = args?['transaction'];

                    if (transaction == null) {
                      return const ErrorView(message: 'Transaction not found');
                    }

                    return TransactionDetail(
                        transaction: transaction as TransactionCls);
                  case Routes.transactionList:
                    return const TransactionListView();

                  case Routes.sampleItemList:
                  default:
                    return const SampleItemListView();
                }
              },
            );
          },
        );
      },
    );
  }
}
