import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:iptv/models/status.dart';

class MyStartup extends StatelessWidget {
  const MyStartup({super.key});

  @override
  Widget build(BuildContext context) {
    var status = context.watch<StatusModel>();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 230, 248),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'IPTV',
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 47, 131, 214),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Column(
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.list),
                      onPressed: () {
                        context.go('/channels');
                      },
                      label: Text('频道列表'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.live_tv),
                      onPressed: () {
                        status.play(index: 0);
                        context.go('/video');
                      },
                      label: Text('播放器'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
