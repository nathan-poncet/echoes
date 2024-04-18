import 'dart:async';

import 'package:echoes/src/api/pocketbase.dart';
import 'package:echoes/src/features/echoes/presentation/recorder/echoes_recorder.dart';
import 'package:echoes/src/utils/determine_position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pocketbase/pocketbase.dart';

class EchoesScreen extends ConsumerStatefulWidget {
  const EchoesScreen({super.key});

  @override
  ConsumerState<EchoesScreen> createState() => _EchoesScreenState();
}

class _EchoesScreenState extends ConsumerState<EchoesScreen> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  Timer? _timer;
  Timer? _timerComapreDistance;
  bool _userlocationTracking = true;
  List<RecordModel> echoes = [];
  List<RecordModel> echoesDiscovered = [];

  void _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;
    mapboxMap?.location.updateSettings(LocationComponentSettings(enabled: true, pulsingEnabled: false, showAccuracyRing: true, puckBearingEnabled: true));
    pointAnnotationManager = await mapboxMap?.annotations.createPointAnnotationManager();
  }

  void _onMapLoadedListener(MapLoadedEventData data) async {
    _refreshTrackLocation();

    final pb = ref.read(pocketBaseProvider);

    Future.wait([
      pb.collection('echoes').getFullList(),
      pb.collection('echoes_discovered').getFullList(),
    ]).then((value) {
      final echoesRecords = value[0];
      final echoesDiscoveredRecords = value[1];

      setState(() {
        echoes = echoesRecords;
        echoesDiscovered = echoesDiscoveredRecords;
      });

      _createMarker(echoes, echoesDiscovered);
    });

    // Subscribe to echoes and echoes_discovered collections
    await pb.collection('echoes').subscribe('*', (e) {
      final newEcho = e.record;
      if (newEcho == null) return;
      final newEchoes = echoes.where((echo) => echo.id != newEcho.id).toList()..add(newEcho);
      setState(() {
        echoes = newEchoes;
      });
      _createMarker(echoes, echoesDiscovered);
    });

    await pb.collection('echoes_discovered').subscribe('*', (e) {
      final newEchoDiscovered = e.record;
      if (newEchoDiscovered == null) return;
      final newEchoesDiscovered = echoesDiscovered.where((echo) => echo.id != newEchoDiscovered.id).toList()..add(newEchoDiscovered);
      setState(() {
        echoesDiscovered = newEchoesDiscovered;
      });
      _createMarker(echoes, echoesDiscovered);
    });
  }

  void _onScrollListener(ScreenCoordinate _) {
    _userlocationTracking = false;
  }

  void _refreshTrackLocation() async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (!_userlocationTracking) {
        _timer?.cancel();
        return;
      }

      final puckLocation = await determinePosition();

      mapboxMap?.flyTo(CameraOptions(center: Point(coordinates: Position(puckLocation.longitude, puckLocation.latitude)).toJson(), zoom: 14, pitch: 0), null);
    });
  }

  void _focusOnUserLocation() async {
    _userlocationTracking = true;
    _refreshTrackLocation();
  }

  Future<void> _createMarker(List<RecordModel> echoes, List<RecordModel> echoesDiscoveredRecords) async {
    // Delete all markers
    await pointAnnotationManager?.deleteAll();
    // Create a list of markers
    await pointAnnotationManager?.createMulti((await Future.wait(echoes.map((record) async {
      final coordinates = record.getDataValue<Map<String, dynamic>?>('location');

      if (coordinates == null) return null;

      final point = Point(coordinates: Position(coordinates["lng"]!, coordinates["lat"]!));
      final echoesIsDiscovered = echoesDiscoveredRecords.any((echoesDiscoveredRecord) => echoesDiscoveredRecord.getDataValue<String>('echo') == record.id);

      final ByteData bytes = await rootBundle.load(echoesIsDiscovered ? 'assets/icons/marker-unlock.png' : 'assets/icons/marker-lock.png');
      final Uint8List list = bytes.buffer.asUint8List();

      return PointAnnotationOptions(
        geometry: point.toJson(),
        image: list,
        // ignore: use_build_context_synchronously
        iconSize: 1.0 * MediaQuery.of(context).devicePixelRatio / 3.5,
      );
    })))
        .whereType<PointAnnotationOptions>()
        .toList());
  }

  void _compareDistance(Position location) async {
    // Detect if the puck is inside a radius of 10 meters of an echo
    final detectedEchoes = echoes.where((echo) {
      final isDiscovered = echoesDiscovered.any((echoDiscovered) => echoDiscovered.getDataValue<String>('echo') == echo.id);
      if (isDiscovered) return false;

      final coordinates = echo.getDataValue<Map<String, dynamic>?>('location');
      if (coordinates == null) return false;

      final echoPosition = Position(coordinates["lng"]!, coordinates["lat"]!);

      final distanceInMeters =
          geolocator.Geolocator.distanceBetween(echoPosition.lat.toDouble(), echoPosition.lng.toDouble(), location.lat.toDouble(), location.lng.toDouble());

      return distanceInMeters < 30;
    });

    for (var e in detectedEchoes) {
      final pb = ref.read(pocketBaseProvider);
      try {
        await pb.collection('echoes_discovered').create(body: {'echo': e.id, 'user': pb.authStore.model.id});
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _timerComapreDistance = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final location = await determinePosition();
      _compareDistance(Position(location.longitude, location.latitude));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerComapreDistance?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String accessToken = const String.fromEnvironment("MAPBOX_PUBLIC_ACCESS_TOKEN");
    MapboxOptions.setAccessToken(accessToken);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            MapWidget(
              onMapCreated: _onMapCreated,
              onMapLoadedListener: _onMapLoadedListener,
              onScrollListener: _onScrollListener,
            ),
            const Positioned(
              right: 0,
              left: 0,
              bottom: 20,
              child: EchoesRecorder(),
            )
          ],
        ),
        floatingActionButton: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.gps_fixed),
            onPressed: _focusOnUserLocation,
            tooltip: 'Focus on user location',
          ),
        ));
  }
}
