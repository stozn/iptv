import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:iptv/models/channels.dart';

class StatusModel extends ChangeNotifier {
  late ChannelListModel _channelList;
  late Channel _curChannel;
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  int? bufferDelay;
  bool loading = false;

  ChannelListModel get channelList => _channelList;
  Channel get curChannel => _curChannel;
  int get num => _channelList.channels.length;
  ChewieController? get chewieController => _chewieController;

  set channelList(ChannelListModel newChannelList) {
    _channelList = newChannelList;
    notifyListeners();
  }

  Future<void> play({int? index, String? name}) async {
    if (index != null) {
      _curChannel =
          _channelList.get(_channelList.channels.keys.toList()[index]);
    } else if (name != null) {
      _curChannel = _channelList.get(name);
    }
    await initializePlayer();
    notifyListeners();
  }

  Future<void> playCustom(String name, String src) async {
    _curChannel = Channel(name, src);
    if (_chewieController == null) await initializePlayer();
    notifyListeners();
  }

  void addChannel(String name, String src) {
    _channelList.add(name, src);
    notifyListeners();
  }

  void delChannel({String? name, int? index}) {
    if (name != null) {
      _channelList.del(name);
    } else if (index != null) {
      _channelList.del(_channelList.channels.keys.toList()[index]);
    }
    notifyListeners();
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      autoInitialize: true,
      looping: false,
      isLive: true,
      allowedScreenSleep: false,
      showOptions: false,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 3),
    );
  }

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(curChannel.src));
    await _controller.initialize();
    _createChewieController();
    print(curChannel.name);
    print(curChannel.src);
    loading = false;
  }

  Future<void> toggleVideo() async {
    loading = true;
    notifyListeners();
    List keys = channelList.channels.keys.toList();
    int next = 0;
    for (int i = 0; i < keys.length - 1; i++) {
      if (keys[i] == curChannel.name) next = i + 1;
    }
    play(name: keys[next]);
    await _controller.play();
    loading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    play(name: curChannel.name);
    await _controller.play();
    notifyListeners();
  }
}
