import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prtracker/services/records_service.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Init {
  static Future initialize() async {
    String appDirPath = await _createAppDirectory();
    await _initSembast(appDirPath);
    // await _initMediaDirectory(appDirPath);
    _registerRepositories(appDirPath);
  }

  static Future<String> _createAppDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return (await appDir.create(recursive: true)).path;
  }

  static Future _initSembast(String appDirPath) async {
    final databasePath = join(appDirPath, 'sembast.db');
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }

  // static Future _initMediaDirectory(String appDirPath) async {
  //   final mediaPath = join(appDirPath, 'media');
  //   final Directory mediaDir =
  //       await Directory(mediaPath).create(recursive: false);
  //   GetIt.I.registerSingleton<Directory>(mediaDir);
  // }

  static _registerRepositories(String appDirPath) {
    GetIt.I.registerLazySingleton<RecordsService>(
        () => RecordsService(appDocumentsDirectoryPath: appDirPath));
  }
}
