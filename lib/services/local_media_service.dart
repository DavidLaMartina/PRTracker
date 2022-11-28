import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:prtracker/config/constants.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class LocalMediaService {
  final String appDirPath;
  final String tempDirPath;

  LocalMediaService({required this.appDirPath, required this.tempDirPath});

  Future<String?> saveXFileToDisk(XFile? xFile, {String? name}) async {
    if (xFile == null) {
      return null;
    }
    final fileName =
        (name != null && name.isNotEmpty) ? name : xFile.hashCode.toString();
    final relativePath =
        path.join(MEDIA_DIR_NAME, fileName) + path.extension(xFile.path);
    await xFile.saveTo(path.join(appDirPath, relativePath));
    return relativePath;
  }

  Future<String?> saveFileToDisk(File? file, {String? name}) async {
    if (file == null) {
      return null;
    }
    final fileName =
        (name != null && name.isNotEmpty) ? name : file.hashCode.toString();
    final relativePath =
        path.join(MEDIA_DIR_NAME, fileName) + path.extension(file.path);
    await file.copy(path.join(appDirPath, relativePath));
    return relativePath;
  }

  Future<String?> generateThumbnailFromVideoFile(XFile videoFile) async {
    return await VideoThumbnail.thumbnailFile(
        video: videoFile.path,
        thumbnailPath: tempDirPath,
        imageFormat: ImageFormat.PNG,
        timeMs: 1,
        quality: 50);
  }

  XFile? openXFileFromDisk(String relativePath) {
    return XFile(path.join(appDirPath, relativePath));
  }

  File openFileFromDisk(String relativePath) {
    final file = File(path.join(appDirPath, relativePath));
    return file;
  }

  void deleteFileFromDisk(String relativePath) async {
    final file = File(path.join(appDirPath, relativePath));
    await file.delete(recursive: false);
  }
}
