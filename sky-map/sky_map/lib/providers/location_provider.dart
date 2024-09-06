import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class LocationProvider extends ChangeNotifier {
  // Останнє отримане місцезнаходження
  Position _currentPositionProvider = Position(
  latitude: 0.0,
  longitude: 0.0,
  timestamp: DateTime.now(),
  accuracy: 0.0,
  altitude: 0.0,
  heading: 0.0,
  speed: 0.0,
  speedAccuracy: 0.0,
);



  Future<void> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    final Logger logger = Logger();

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logger.e('Location services are disabled');
      return;
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        logger.e('Location permissions are denied forever');
        return;
      }
    }

    // Get current location
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      updateLocation(position);
    } catch (e) {
      logger.e('Error getting current location: $e');
    }
  }

  void updateLocation(Position position) {
    _currentPositionProvider = position;
    notifyListeners();
  }

  Position get currentPosition => _currentPositionProvider;
}

