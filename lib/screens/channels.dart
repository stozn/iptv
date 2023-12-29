import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iptv/models/status.dart';

class MyChannels extends StatelessWidget {
  const MyChannels({super.key});

  @override
  Widget build(BuildContext context) {
    var status = context.watch<StatusModel>();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 230, 248),
      appBar: AppBar(
        title: Text('频道列表(${status.num})'),
        backgroundColor: Color.fromARGB(255, 185, 230, 248),
        actions: [
          IconButton(
              icon: const Icon(Icons.live_tv),
              onPressed: () {
                status.play(index: 0);
                context.go('/video');
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ChannelList(),
      ),
    );
  }
}

class ChannelList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var status = context.watch<StatusModel>();

    return ListView.builder(
      itemCount: status.num,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.tv),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            status.delChannel(index: index);
          },
        ),
        title: Text(status.channelList.channels.keys.toList()[index]),
        onTap: () {
          status.play(index: index);
          context.go('/video');
        },
      ),
    );
  }
}
