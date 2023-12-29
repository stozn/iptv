import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:chewie/chewie.dart';
import 'package:iptv/models/status.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoApp extends StatelessWidget {
  const VideoApp({super.key});

  @override
  Widget build(BuildContext context) {
    var status = context.watch<StatusModel>();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 230, 248),
      appBar: AppBar(
        title: Consumer<StatusModel>(
          builder: (context, status, child) => Text(status.curChannel.name),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => context.go('/channels'),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () => launchUrl(Uri.parse(status.curChannel.src)),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 185, 230, 248),
      ),
      body: Column(children: [
        Expanded(
          child: status.chewieController != null &&
                  status.chewieController!.videoPlayerController.value
                      .isInitialized
              ? Chewie(
                  controller: status.chewieController!,
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('加载中'),
                  ],
                ),
        ),
        Expanded(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: status.refresh,
                icon: Icon(Icons.refresh),
                label: Text('刷新'),
              ),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 130,
                  height: 40,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.list),
                    onPressed: () => context.go('/channels'),
                    label: Text('全部频道'),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 130,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: status.toggleVideo,
                    icon: Icon(
                      status.loading ? Icons.hourglass_bottom : Icons.autorenew,
                    ),
                    label: Text('切换频道'),
                  ),
                ),
              ]),
            ],
          ),
        )
      ]),
    );
  }
}
