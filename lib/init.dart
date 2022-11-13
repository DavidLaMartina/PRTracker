import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prtracker/services/local_media_service.dart';
import 'package:prtracker/services/records_service.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Init {
  static Future initialize() async {
    final String appDirPath = await _createAppDirectory();
    final String tempDirPath = (await getTemporaryDirectory()).path;
    await _initSembast(appDirPath);
    _registerRepositories(appDirPath, tempDirPath);
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

  static _registerRepositories(String appDirPath, String tempDirPath) {
    GetIt.I.registerLazySingleton<RecordsService>(() => RecordsService());
    GetIt.I.registerLazySingleton<LocalMediaService>(() =>
        LocalMediaService(appDirPath: appDirPath, tempDirPath: tempDirPath));
  }
}
