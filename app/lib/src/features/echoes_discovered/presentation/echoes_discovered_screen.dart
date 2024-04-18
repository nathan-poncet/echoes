import 'package:echoes/src/api/pocketbase.dart';
import 'package:echoes/src/common_widgets/layout/responsive_center.dart';
import 'package:echoes/src/constants/app_sizes.dart';
import 'package:echoes/src/constants/paddings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:pocketbase/pocketbase.dart';

class EchoesDiscoveredScreen extends ConsumerStatefulWidget {
  const EchoesDiscoveredScreen({super.key});

  @override
  ConsumerState<EchoesDiscoveredScreen> createState() => _EchoesDiscoveredScreenState();
}

class _EchoesDiscoveredScreenState extends ConsumerState<EchoesDiscoveredScreen> {
  List<RecordModel> echoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getEchoes();
  }

  void getEchoes() async {
    final pb = ref.read(pocketBaseProvider);
    final records = await pb.collection('echoes_discovered').getFullList(expand: "echo.author,user");

    setState(() {
      echoes = records;
      isLoading = false;
    });

    /* Subscription */
    pb.collection('echoes_discovered').subscribe('*', (e) {
      final newEcho = e.record;
      if (newEcho == null) return;
      final newEchoes = echoes.where((echo) => echo.id != newEcho.id).toList()..add(newEcho);
      setState(() {
        echoes = newEchoes;
      });
    });
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pb = ref.watch(pocketBaseProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ResponsiveCenter(
          padding: Paddings.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Echoes Discovered', style: Theme.of(context).textTheme.headlineMedium),
              gapH8,
              Text('This is the echoes discovered, you can listen to the echoes of the world', style: Theme.of(context).textTheme.bodyMedium),
              gapH24,
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (echoes.isEmpty)
                const Center(child: Text('No echoes discovered'))
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: echoes.length,
                  itemBuilder: (context, index) {
                    final echo = echoes[index].expand['echo']?.first;

                    if (echo == null) return const SizedBox();

                    final url = pb.files.getUrl(echo, echo.getDataValue<String>('audio')).toString();
                    final player = AudioPlayer();
                    player.setSource(UrlSource(url));

                    return Card(
                        child: Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(echo.expand['author']?.first.getDataValue<String>('name') ?? 'Unknown', style: Theme.of(context).textTheme.titleMedium),
                        Text(echo.created),
                        Row(
                          children: [
                            StreamBuilder(
                                stream: player.onPlayerStateChanged,
                                builder: (context, snapshot) {
                                  final state = snapshot.data;
                                  return IconButton(
                                    icon: switch (state) {
                                      PlayerState.playing => const Icon(Icons.pause),
                                      PlayerState.paused => const Icon(Icons.play_arrow),
                                      _ => const Icon(Icons.play_arrow),
                                    },
                                    onPressed: () {
                                      switch (state) {
                                        case PlayerState.playing:
                                          player.pause();
                                          break;
                                        case PlayerState.paused:
                                          player.resume();
                                          break;
                                        default:
                                          player.play(UrlSource(url));
                                      }
                                    },
                                  );
                                }),
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
                                        max: snapshot.snapshot1.data!.inMilliseconds.toDouble() + 100,
                                        onChanged: (value) {
                                          player.seek(Duration(milliseconds: value.toInt()));
                                        },
                                      ),
                                    ],
                                  );
                                }),
                            StreamBuilder(
                                stream: player.onDurationChanged,
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return const Text('00:00');
                                  }
                                  return Text(snapshot.data.toString().substring(0, 7));
                                }),
                          ],
                        ),
                      ]),
                    ));
                  },
                  separatorBuilder: (context, index) => gapH12,
                )
            ],
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double sliderValue;

  WavePainter(this.sliderValue);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    var path = Path();

    // Créez ici le design en forme de vague
    path.moveTo(0, size.height);
    path.lineTo(size.width * sliderValue / 100, size.height);
    // Ajoutez les courbes pour simuler les vagues
    path.quadraticBezierTo(
      size.width * sliderValue / 100 + 10,
      size.height - 30,
      size.width * sliderValue / 100 + 20,
      size.height,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
