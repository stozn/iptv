import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

void main() => runApp(VideoApp());

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 6, 159, 230)),
    disabledColor: Colors.grey.shade400,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme:
        ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 6, 159, 230)),
    disabledColor: Colors.grey.shade400,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  int? bufferDelay;
  bool loading = false;

  String curChannel = 'CCTV-1';
  Map srcs = {
    'CCTV-1':
        'http://ottrrs.hl.chinamobile.com/PLTV/88888888/224/3221226016/index.m3u8',
    'CCTV-2':
        'http://ottrrs.hl.chinamobile.com/PLTV/88888888/224/3221225588/index.m3u8',
  };

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController?.dispose();
  }

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        // 'http://ottrrs.hl.chinamobile.com/PLTV/88888888/224/3221226016/index.m3u8'));
        srcs[curChannel]));
    await _controller.initialize();

    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      autoInitialize: true,
      looping: false,
      isLive: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 3),
    );
  }

  Future<void> toggleVideo() async {
    setState(() {
      loading = true;
    });

    await _controller.pause();
    for (var ch in srcs.keys) {
      if (ch != curChannel) {
        curChannel = ch;
        break;
      }
    }
    await initializePlayer();
    await _controller.play();

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      theme: AppTheme.light.copyWith(
        platform: TargetPlatform.windows,
      ),
      home: Scaffold(
        // backgroundColor: Color.fromARGB(255, 119, 202, 240),
        body: Column(children: [
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton.icon(
                onPressed: () {
                  _chewieController?.enterFullScreen();
                },
                icon: Icon(Icons.fullscreen),
                label: Text('全屏'),
              ),
              SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: toggleVideo,
                icon: Icon(
                  loading ? Icons.hourglass_bottom : Icons.autorenew,
                ),
                label: Text('切换频道'),
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
