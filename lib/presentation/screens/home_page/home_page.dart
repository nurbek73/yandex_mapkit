import 'dart:async';

import 'package:final_proj/core/services/map_services/yandex_map_services.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initPermission().ignore();
  }

  List<MapObject> mapObject = [];
  final mapControllerCompleter = Completer<YandexMapController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: [
          YandexMap(
            mapObjects: mapObject,
            onMapTap: (point) {
              print(point.latitude);
              print(point.longitude);
            },
            onMapCreated: (controller) {
              mapControllerCompleter.complete(controller);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = BishkekLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 12,
        ),
      ),
    );
  }

  void addObjects({required AppLatLong appLatLong}) {
    final myLocationMarker = PlacemarkMapObject(
      mapId: const MapObjectId('currentLocation '),
      point: Point(latitude: appLatLong.lat, longitude: appLatLong.long),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/images/mark.png'),
            rotationType: RotationType.rotate),
      ),
    );

    mapObject.add(myLocationMarker);
  }
}
