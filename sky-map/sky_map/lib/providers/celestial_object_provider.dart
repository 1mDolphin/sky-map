import 'package:flutter/material.dart';
import '../models/solar_system_object.dart';
import '../models/star_object.dart';

class CelestialObjectsProvider extends ChangeNotifier {
  List<SolarSystemObject> _solarSystemObjectList = [];
  Map<String, List<StarObject>> _starObjectListMap = {};

   void updateSolarSystemObjectList(List<SolarSystemObject> newList) {
    _solarSystemObjectList = newList;
    notifyListeners();
  }

  void updateStarObjectList(Map<String, List<StarObject>> newList) {
    _starObjectListMap = newList;
    notifyListeners();
  }

  // Getter to get a list of celestial objects
  List<SolarSystemObject> get solarSystemObjectList => _solarSystemObjectList;
  Map<String, List<StarObject>> get starObjectListMap => _starObjectListMap;
}
