import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:echoes/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class EchoesListener extends StatefulWidget {
  final Directory appDirectory;
  final String path;
  final VoidCallback? onPressClose;

  const EchoesListener({super.key, required this.appDirectory, required this.path, this.onPressClose});

  @override
  State<EchoesListener> createState() => _EchoesListenerState();
}

class _EchoesListenerState extends State<EchoesListener> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.setSource(DeviceFileSource(widget.path));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8, horizontal: Sizes.p12),
      margin: const EdgeInsets.symmetric(vertical: Sizes.p8, horizontal: Sizes.p12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder(
              stream: player.onPlayerStateChanged,
              builder: (context, snapshot) => IconButton(
                  onPressed: () async {
                    if (snapshot.data == PlayerState.playing) {
                      await player.pause();
                    } else {
                      await player.resume();
                    }
                  },
                  icon: Icon(snapshot.data == PlayerState.playing ? Icons.stop : Icons.play_arrow),
                  color: Colors.white)),
          StreamBuilder2<Duration, Duration>(
              streams: StreamTuple2(player.onDurationChanged, player.onPositionChanged),
              initialData: InitialDataTuple2(Duration.zero, Duration.zero),
              builder: (context, snapshot) {
                if (snapshot.snapshot1.data == null || snapshot.snapshot2.data == null) {
                  return const SizedBox();
                }

                return Stack(
                  children: <Widget>[
                    Slider(
                      value: snapshot.snapshot2.data!.inMilliseconds.toDouble(),
                      min: 0,
                      max: snapshot.snapshot1.data!.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        player.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
