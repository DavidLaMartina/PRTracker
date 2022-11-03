import 'package:flutter/material.dart';
import 'package:prtracker/screens/record_edit_screen.dart';
import 'package:prtracker/screens/record_details_screen.dart';
import 'package:prtracker/screens/record_list_screen.dart';
import 'init.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future _init = Init.initialize();

  final routes = {
    // RecordListScreen.route: (context) => RecordListScreen(),
    RecordEditScreen.route: (context) => RecordEditScreen(),
    RecordDetailsScreen.route: (context) => RecordDetailsScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PR Tracker',
        theme: ThemeData.dark(),
        restorationScopeId: 'app',
        initialRoute: RecordListScreen.route,
        routes: routes,
        home: FutureBuilder(
            future: _init,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return RecordListScreen();
              } else {
                return const Material(
                    child: Center(child: CircularProgressIndicator()));
              }
            }));
  }
}
