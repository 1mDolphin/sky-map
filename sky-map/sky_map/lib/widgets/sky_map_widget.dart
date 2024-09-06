import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../utils/celestial_object_painter.dart';
import '../providers/celestial_object_provider.dart';
import '../providers/location_provider.dart';
import '../providers/sensor_provider.dart';
import '../widgets/info_object_widget.dart';

class SkyMapWidget extends StatefulWidget {
  const SkyMapWidget({Key? key}) : super(key: key);

  @override
  _SkyMapWidgetState createState() => _SkyMapWidgetState();
}

class _SkyMapWidgetState extends State<SkyMapWidget> {
  double zoomLevel = 1.8;
  Offset? clickPosition;
  Offset? tapPosition; 

  @override
  Widget build(BuildContext context) {
    return Consumer2<CelestialObjectsProvider, SensorProvider>(
      builder: (context, celestialProvider, sensorProvider, _) {
        final solarSystemObjects = celestialProvider.solarSystemObjectList;
        final starObjectListMap = celestialProvider.starObjectListMap;
        final currentPosition =
            Provider.of<LocationProvider>(context).currentPosition;

        double yaw = sensorProvider.yaw;
        double rotationAngle = math.pi / 180 * yaw;

        double tiltAngle = sensorProvider.tiltAngle;
        double normalizedTilt = (tiltAngle / (math.pi / 2)).clamp(-1.0, 1.0);
        double offsetY = 1 - normalizedTilt.abs();
        Offset mapOffset = Offset(0, offsetY);

        void handleDoubleTap(Offset offset) {
          setState(() {
            clickPosition = offset;
            double screenHeight = MediaQuery.of(context).size.height;
            if (offset.dy < screenHeight / 2) {
              showInfo(context, 'sun', solarSystemObjects); 
            } else {
              showInfo(context, 'mars', solarSystemObjects); 
            }
          });
        }

        return GestureDetector(
          onDoubleTapDown: (details) {
            handleDoubleTap(details.localPosition);
          },
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(double.infinity),
            minScale: 0.5,
            maxScale: 5.0,
            onInteractionUpdate: (ScaleUpdateDetails details) {
              setState(() {
                zoomLevel = 1.8 * details.scale;
              });
            },
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Transform.rotate(
                  angle: rotationAngle,
                  child: CustomPaint(
                    painter: CelestialObjectPainter(
                      zoomLevel: zoomLevel,
                      mapOffset: mapOffset,
                      solarSystemObjects: solarSystemObjects,
                      starsObjects: starObjectListMap,
                      currentPosition: currentPosition,
                      clickPosition: clickPosition,
                      rotationAngle: rotationAngle,
                      onObjectTap: (object, position) {
                            setState(() {
                              tapPosition = position; 
                            });
                          },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
