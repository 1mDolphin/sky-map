import 'package:flutter/material.dart';
import '../models/solar_system_object.dart' as custom;

void showInfo(BuildContext context, String id, List<custom.SolarSystemObject> solarSystemObjects) {
  custom.SolarSystemObject? celestialObject;
  custom.TableCell? targetCell;

  for (final solarSystemObject in solarSystemObjects) {
    if (solarSystemObject.cells.isNotEmpty && solarSystemObject.cells[0].id == id) {
      celestialObject = solarSystemObject;
      targetCell = solarSystemObject.cells[0]; 
      break;
    }
  }
  if (celestialObject != null && targetCell != null) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${celestialObject!.name}'),
        content: Text('Distance from Earth: ${targetCell!.distance.km} km.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No results found'),
        content: Text('Unable to find information about an object with an identifier $id.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
