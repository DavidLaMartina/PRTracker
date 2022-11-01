import 'package:flutter/material.dart';
import 'package:prtracker/screens/new_record_screen.dart';
import 'package:prtracker/screens/record_details_screen.dart';
import 'package:prtracker/screens/record_list_screen.dart';

class App extends StatelessWidget {
  final routes = {
    RecordListScreen.route: (context) => RecordListScreen(),
    NewRecordScreen.route: (context) => NewRecordScreen(),
    RecordDetailsScreen.route: (context) => RecordDetailsScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PR Tracker',
        theme: ThemeData.dark(),
        initialRoute: RecordListScreen.route,
        routes: routes);
  }
}
