import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prtracker/services/records_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

late RecordsService recordsService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  recordsService = RecordsService();
  runApp(App());
}
