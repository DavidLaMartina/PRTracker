import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:prtracker/screens/record_edit_screen.dart';
import 'package:prtracker/screens/record_details_screen.dart';
import 'package:prtracker/screens/record_list_screen.dart';
import 'package:prtracker/theme.dart';
import 'package:prtracker/views/root_layout.dart';
import 'init.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final themeSettings = ValueNotifier(ThemeSettings(
    sourceColor: Colors.red,
    themeMode: ThemeMode.system,
  ));

  final Future _init = Init.initialize();

  final routes = {
    RecordListScreen.route: (context) =>
        RootLayout(child: RecordListScreen(), currentIndex: 0),
    RecordEditScreen.route: (context) =>
        RootLayout(child: RecordEditScreen(), currentIndex: 1),
    RecordDetailsScreen.route: (context) =>
        RootLayout(child: RecordDetailsScreen(), currentIndex: 0)
  };

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: ((lightDynamic, darkDynamic) => ThemeProvider(
            lightDynamic: lightDynamic,
            darkDynamic: darkDynamic,
            settings: themeSettings,
            child: NotificationListener<ThemeSettingsChange>(
                onNotification: (notification) {
                  themeSettings.value = notification.settings;
                  return true;
                },
                child: ValueListenableBuilder<ThemeSettings>(
                  valueListenable: themeSettings,
                  builder: ((context, value, child) {
                    final theme = ThemeProvider.of(context);
                    return FutureBuilder(
                        future: _init,
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return MaterialApp(
                              debugShowCheckedModeBanner: false,
                              title: 'PR Tracker',
                              theme:
                                  theme.light(themeSettings.value.sourceColor),
                              darkTheme:
                                  theme.dark(themeSettings.value.sourceColor),
                              themeMode: theme.themeMode(),
                              routes: routes,
                            );
                          } else {
                            return const Material(
                                child:
                                    Center(child: CircularProgressIndicator()));
                          }
                        }));
                  }),
                )))));
  }
}
