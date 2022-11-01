import 'package:flutter/material.dart';
import 'package:prtracker/screens/new_record_screen.dart';
import 'package:prtracker/screens/record_details_screen.dart';
import 'package:prtracker/screens/record_list_screen.dart';
import 'package:prtracker/widgets/pr_tracker_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/constants.dart';

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

// class AppState extends State<App> {
//   late ThemeData themeData;
//   late SharedPreferences prefs;

//   void toggleTheme(bool darkModeOn) {
//     setState(() {
//       widget.preferences.setBool(DARK_MODE_ON_KEY, darkModeOn);
//       themeData = darkModeOn ? ThemeData.dark() : ThemeData.light();
//     });
//   }

//   void getTheme() {
//     setState(() {
//       prefs = widget.preferences;
//       if (prefs.containsKey(DARK_MODE_ON_KEY)) {
//         toggleTheme(prefs.getBool(DARK_MODE_ON_KEY) ?? false);
//       } else {
//         toggleTheme(false);
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     toggleTheme(widget.preferences.getBool(DARK_MODE_ON_KEY) ?? false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(title: 'PR Tracker', theme: themeData, home: null);
//   }
// }
