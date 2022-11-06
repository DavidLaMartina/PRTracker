import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:prtracker/models/record.dart';

const mediaDir = 'media';

// TODO: If this doesn't work, then do it the manual way by reading bytes from XFile
// and then wreiting those bytes to file
Future<String> saveXFileToDisk(XFile file, String dirPath,
    {String filename = ''}) async {
  final String permFilename;
  if (filename.isNotEmpty) {
    permFilename = filename;
  } else {
    permFilename = file.hashCode.toString();
  }
  final relativePath = path.join(mediaDir, permFilename);
  final permPath = path.join(dirPath, relativePath);
  // await file.saveTo(permPath);
  return relativePath;
}

Future<String> saveFileToDiskByPath(String filePath, String dirPath,
    {String filename = ''}) async {
  final currentFile = File(filePath);
  final String permFilename;
  if (filename.isNotEmpty) {
    permFilename = filename;
  } else {
    permFilename = currentFile.hashCode.toString();
  }
  final relativePath = path.join(mediaDir, permFilename);
  final permPath = path.join(dirPath, relativePath);
  final File copiedFile = await currentFile.copy(permPath);
  // return copiedFile.path;
  return relativePath;
}
