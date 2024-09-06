// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/celestial_object_provider.dart';
import '../services/api_solar_system_service.dart';
import '../services/api_constellation_service.dart';
import '../models/solar_system_object.dart';
import '../models/star_object.dart';
import '../widgets/sky_map_widget.dart';
import '../providers/location_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();

    _initPage();
  }

  Future<void> _initPage() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      locationProvider.updateLocation(position);
    } catch (e) {
      logger.e('Error getting current location: $e');
    }
    if (mounted) {
      await _fetchSolarSystemData();
      await _fetchStarsInConstellation();
    }
  }


  Future<void> _fetchSolarSystemData() async {
    if (!mounted) return;
    const String timeFormat = 'HH:mm:ss';
    final currentPosition = Provider.of<LocationProvider>(context, listen: false).currentPosition;
    final localTimestamp = currentPosition.timestamp?.toLocal();
    final date = localTimestamp?.toIso8601String().split('T')[0];
    final time = DateFormat(timeFormat).format(DateTime.now());

    final solarSystemData = await SolarSystemService.fetchSolarSystemData(
      latitude: currentPosition.latitude.toString(),
      longitude: currentPosition.longitude.toString(),
      elevation: '0',
      fromDate: date ?? '',
      toDate: date ?? '',
      time: time,
    );

    final List<dynamic> rows = solarSystemData['data']['table']['rows'];
    final List<SolarSystemObject> celestialObjectDataList = [];
    for (var row in rows) {
      celestialObjectDataList.add(SolarSystemObject.fromJson(row));
    }

    try {
      if (mounted) {
        final celestialObjectProvider =
            Provider.of<CelestialObjectsProvider>(context, listen: false);
        celestialObjectProvider.updateSolarSystemObjectList(
            celestialObjectDataList); // Оновлюємо дані в провайдер
      }
    } catch (e) {
      logger.e('Error fetching Solar System data: $e');
    }
  }

Future<void> _fetchStarsInConstellation() async {
  if (!mounted) return;

  final List<String> constellationsToDisplay = ['Perseus', 'Lyra', 'Gemini', 'Auriga', 'Cygnus', 'Ursa Major']; // 'Perseus', 'Lyra', 'Canis Minor', 'Gemini', 'Auriga', 'Cygnus', 'Ursa Major'

  try {
    final Map<String, List<StarObject>> constellationStarsMap = {};
    for (final constellation in constellationsToDisplay) {
      final List<StarObject> starsInConstellation = await fetchStarsInConstellation(constellation);
      constellationStarsMap[constellation] = starsInConstellation;
    }
    if (mounted) {
      final celestialObjectProvider = Provider.of<CelestialObjectsProvider>(context, listen: false);
      celestialObjectProvider.updateStarObjectList(constellationStarsMap);
    }
  } catch (e) {
    logger.e('Error fetching Star data: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SKY MAP'),
      ),
      body: const Center(
        child: SkyMapWidget(),
      ),
    );
  }
}
