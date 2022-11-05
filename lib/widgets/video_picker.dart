import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoPickerButton extends StatelessWidget {
  final ImagePicker _videoPicker = ImagePicker();
  final Function(XFile? pickedFile) onVideoPicked;

  VideoPickerButton({super.key, required this.onVideoPicked});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          XFile? pickedFile =
              await _videoPicker.pickVideo(source: ImageSource.gallery);
          onVideoPicked(pickedFile);
        },
        child: const Text('Select video'));
  }
}
