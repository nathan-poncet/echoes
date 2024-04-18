import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:echoes/src/api/pocketbase.dart';
import 'package:echoes/src/common_widgets/feedback/dialog/alert_dialogs.dart';
import 'package:echoes/src/constants/app_sizes.dart';
import 'package:echoes/src/features/echoes/presentation/listener/echoes_listener.dart';
import 'package:echoes/src/utils/modal_bottom_sheet/show_modal_bottom_sheet_intrinsic_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class EchoesRecorder extends ConsumerStatefulWidget {
  const EchoesRecorder({super.key});

  @override
  ConsumerState<EchoesRecorder> createState() => _EchoesRecorderState();
}

class _EchoesRecorderState extends ConsumerState<EchoesRecorder> {
  final Directory appDirectory = Directory.systemTemp;
  late final RecorderController recorderController;

  String? path;
  bool isRecording = false;
  bool isRecordingCompleted = false;

  @override
  void initState() {
    super.initState();
    _initialiseControllers();
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  void _startOrStopRecording() async {
    if (isRecording) {
      recorderController.reset();
      final newPath = await recorderController.stop(false);

      setState(() {
        isRecording = false;
        isRecordingCompleted = true;
        path = newPath;
      });
    } else {
      await recorderController.record(path: path);
      setState(() {
        isRecording = true;
        isRecordingCompleted = false;
      });
    }
  }

  void _onPressClose() {
    setState(() {
      isRecording = false;
      isRecordingCompleted = false;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pb = ref.watch(pocketBaseProvider);

    return Column(
      children: [
        if (isRecording) ...[
          AudioWaveforms(
            enableGesture: true,
            size: Size(MediaQuery.of(context).size.width / 2, 50),
            recorderController: recorderController,
            waveStyle: const WaveStyle(
              waveColor: Colors.white,
              extendWaveform: true,
              showMiddleLine: false,
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), color: Colors.black),
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
          ),
          gapH12,
        ],
        if (!isRecording && isRecordingCompleted && path != null) ...[
          EchoesListener(onPressClose: _onPressClose, appDirectory: appDirectory, path: path!),
          gapH12,
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRecordingCompleted) ...[
              FilledButton(
                onPressed: _onPressClose,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Icon(Icons.delete_outline),
              ),
              gapW12,
            ],
            FilledButton(
              onPressed: _startOrStopRecording,
              child: Icon(isRecording ? Icons.stop : Icons.mic),
            ),
            if (isRecordingCompleted) ...[
              gapW12,
              FilledButton(
                onPressed: () async {
                  try {
                    final position = await _determinePosition();

                    pb.collection('echoes').create(
                      body: {
                        'author': pb.authStore.model.id,
                        'location': '{"lat": ${position.latitude}, "lng": ${position.longitude}}',
                      },
                      files: [
                        http.MultipartFile.fromBytes('audio', File(path!).readAsBytesSync(), filename: 'audio.m4a'),
                      ],
                    );

                    _onPressClose();
                  } catch (e) {
                    if (context.mounted) {
                      showExceptionBottomAlert(
                        context: context,
                        title: "Erreur",
                        exception: "Une erreur s'est produite lors de l'envoi de l'écho",
                      );
                    }
                  } finally {
                    if (context.mounted) {
                      showModalBottomSheetIntrinsicHeight(
                          context: context,
                          title: "Echo Envoyer ✅",
                          description: "Votre écho a été envoyé avec succès. Vous pouvez maintenant l'écouter et le partager avec le monde entier.",
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FilledButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text("ok")),
                            ],
                          ));
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                ),
                child: const Icon(Icons.send),
              ),
            ]
          ],
        )
      ],
    );
  }
}
