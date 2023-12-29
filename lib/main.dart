import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iptv/common/theme.dart';
import 'package:iptv/models/status.dart';
import 'package:iptv/models/channels.dart';
import 'package:iptv/screens/startup.dart';
import 'package:iptv/screens/video.dart';
import 'package:iptv/screens/channels.dart';

void main() {
  runApp(const MyApp());
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const MyStartup(),
          routes: [
            GoRoute(
              path: 'channels',
              builder: (context, state) => const MyChannels(),
            ),
            GoRoute(
              path: 'video',
              builder: (context, state) => const VideoApp(),
            ),
          ]),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => ChannelListModel()),
        ChangeNotifierProxyProvider<ChannelListModel, StatusModel>(
          create: (context) => StatusModel(),
          update: (context, channelList, status) {
            if (status == null) throw ArgumentError.notNull('status');
            status.channelList = channelList;
            status.curChannel =
                channelList.get(channelList.channels.keys.toList()[0]);
            return status;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'IPTV',
        theme: appTheme.copyWith(
          platform: TargetPlatform.windows,
        ),
        routerConfig: router(),
      ),
    );
  }
}
