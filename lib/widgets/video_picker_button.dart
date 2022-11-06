import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPickerButton extends StatelessWidget {
  final ImagePicker _videoPicker = ImagePicker();
  String? _videoThumbnailFilepath;

  final Function(XFile? pickedFile) onVideoPicked;

  VideoPickerButton({super.key, required this.onVideoPicked});

  Future _pickVideo() async {
    final pickedVideoFile =
        await _videoPicker.pickVideo(source: ImageSource.gallery);
    if (pickedVideoFile == null) {
      return;
    }
    final tempDirPath = (await getTemporaryDirectory()).path;
    _videoThumbnailFilepath = await VideoThumbnail.thumbnailFile(
        video: pickedVideoFile.path,
        thumbnailPath: tempDirPath,
        imageFormat: ImageFormat.PNG);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await _pickVideo();
        },
        child: thumbnailDisplay());
  }

  Widget thumbnailDisplay() {
    return _videoThumbnailFilepath != null
        ? Image.file(File(_videoThumbnailFilepath!))
        : const Placeholder();
  }
}
