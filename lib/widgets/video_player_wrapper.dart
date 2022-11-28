import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:prtracker/models/record.dart';
import 'package:prtracker/services/local_media_service.dart';
import 'package:video_player/video_player.dart';

// https://himdeve.com/flutter-tutorials/flutter-tutorial-1-12-video-player-chewie/

class VideoPlayerWrapper extends StatefulWidget {
  final String videoUri;
  const VideoPlayerWrapper({super.key, required this.videoUri});

  @override
  State<VideoPlayerWrapper> createState() => _VideoPlayerWrapperState();
}

class _VideoPlayerWrapperState extends State<VideoPlayerWrapper> {
  final LocalMediaService _localMediaService = GetIt.I.get();
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // https://pub.dev/packages/video_player
    // https://docs.flutter.dev/cookbook/plugins/play-video
    final videoFile = _localMediaService.openFileFromDisk(widget.videoUri);
    _videoController = VideoPlayerController.file(videoFile);
    _initializeVideoPlayerFuture = _videoController.initialize();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: ((context, snapshot) {
            return Center(child: videoPlayer(context, snapshot));
          })),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_videoController.value.isPlaying) {
                _videoController.pause();
              } else {
                _videoController.play();
              }
            });
          },
          child: Icon(_videoController.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow)),
    );
  }

  Widget videoPlayer(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return AspectRatio(
        aspectRatio: _videoController.value.aspectRatio,
        child: VideoPlayer(_videoController),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
