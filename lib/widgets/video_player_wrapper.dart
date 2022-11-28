import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  late ChewieController _chewieController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(
        _localMediaService.openFileFromDisk(widget.videoUri));
    _initializeVideoPlayerFuture = _videoController.initialize();
    // We're waiting until the build to set up the chewie controller
    // because until the video player control inits, we don't have access
    // to the true aspect ratio, which the Chewie Controller requires
    // TODO: Write better version of chewie controller
  }

  void _setupChewieController() {
    _chewieController = ChewieController(
        videoPlayerController: _videoController,
        aspectRatio: _videoController.value.aspectRatio,
        autoInitialize: false,
        autoPlay: false,
        looping: false,
        errorBuilder: ((context, errorMessage) {
          return Center(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(errorMessage)));
        }));
    _chewieController.setVolume(0);
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              _setupChewieController();
              return Center(child: videoPlayer(context, snapshot));
            }));
  }

  Widget videoPlayer(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return Chewie(controller: _chewieController);
    } else {
      return const CircularProgressIndicator();
    }
  }
}
