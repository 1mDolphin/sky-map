// Service for accessing user location data.

import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting current location: $e');
      return Future.error('Error getting current location');
    }
  }

  Stream<Position> watchLocation() {
    return Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 1, // change the minimum distance for updating (in meters)
    );
  }
}


// Latitude (широта) вимірює відстань північ-південь від екватора і виражається в градусах. 
//Значення широти знаходиться в діапазоні від -90 (південна широта) до +90 (північна широта), де нуль відповідає екватору.

// Longitude (довгота) вимірює відстань схід-захід від Гринвіча і також виражається 
//в градусах. Значення довготи знаходиться в діапазоні від -180 до +180, де нуль відповідає лінії Гринвіча, 
//яка проходить через Лондон, Велика Британія.


