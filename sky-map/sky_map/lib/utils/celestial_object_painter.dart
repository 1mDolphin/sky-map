import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import '../models/solar_system_object.dart';
import '../models/star_object.dart';
import '../utils/constants.dart';

class CelestialObjectPainter extends CustomPainter {
  final double zoomLevel;
  final Offset mapOffset;
  final List<SolarSystemObject> solarSystemObjects;
  final Map<String, List<StarObject>> starsObjects;
  final Position currentPosition;
  final Offset? clickPosition;
  final double rotationAngle;
  final void Function(SolarSystemObject, Offset) onObjectTap;

  CelestialObjectPainter({
    required this.zoomLevel,
    required this.mapOffset,
    required this.solarSystemObjects,
    required this.starsObjects,
    required this.currentPosition,
    required this.clickPosition,
    required this.rotationAngle,
    required this.onObjectTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double circleRadius =
        math.min(size.width, size.height) / 2 * zoomLevel;
    final Offset center =
        Offset(size.width / 2 + mapOffset.dx, size.height / 2 + mapOffset.dy);
    final Paint paint = Paint()..color = Colors.black;
    canvas.drawCircle(center, circleRadius, paint);

    _drawSolarSystemObjects(canvas, center, circleRadius, size);
    _drawStarObjects(canvas, center, circleRadius);
    _drawCompass(canvas, center, circleRadius);

    // if (clickPosition != null) {
    //   print("Clicked at: (${clickPosition!.dx}, ${clickPosition!.dy})");
    // }
  }

  void _drawSolarSystemObjects(
      Canvas canvas, Offset center, double circleRadius, Size size) {
    for (final solarSystemObject in solarSystemObjects) {
      final ObPosition position = solarSystemObject.cells[0].position;
      final double altitude = double.parse(position.horizontal.altitude);
      final double azimuth = -double.parse(position.horizontal.azimuth);
      final double objectDistanceFromCenter =
          circleRadius - circleRadius * altitude / 90;
      final double objectAngle = math.pi / 180 * azimuth;
      final double objectX =
          center.dx + objectDistanceFromCenter * math.sin(objectAngle);
      final double objectY =
          center.dy - objectDistanceFromCenter * math.cos(objectAngle);

      if (math.pow(objectX - center.dx, 2) + math.pow(objectY - center.dy, 2) <=
          math.pow(circleRadius, 2)) {
        final Paint objectPaint = getObjectPaint(solarSystemObject.id);
        final double objectRadius =
            getObjectRadius(solarSystemObject.id) / zoomLevel;
        canvas.drawCircle(Offset(objectX, objectY), objectRadius, objectPaint);

        _drawLabelSolarSystem(canvas, solarSystemObject.name,
            Offset(objectX + objectRadius, objectY));

        if (clickPosition != null &&
            isPointInsideObject(
                clickPosition!, Offset(objectX, objectY), objectRadius, size, center)) {
            onObjectTap(solarSystemObject, Offset(objectX, objectY)); 
        }
      }
    }
  }

  bool isPointInsideObject(Offset clickPosition, Offset objectCenter,
      double objectRadius, Size screenSize, Offset center) {
    Offset transformedClickPosition = clickPosition -
        Offset(screenSize.width / 2, screenSize.height / 2) -
        mapOffset;

    // print('Handled');
    // print(transformedClickPosition);
    // print(objectCenter);
    return (transformedClickPosition - objectCenter).distance <= objectRadius;
  }

  void _drawStarObjects(Canvas canvas, Offset center, double circleRadius) {
    final double observerLatitude = currentPosition.latitude;
    final double observerLongitude = currentPosition.longitude;
    final double observerLatitudeRadians = math.pi / 180 * observerLatitude;
    final double observerLongitudeRadians = math.pi / 180 * observerLongitude;

    for (final constellationStars in starsObjects.values) {
      double totalX = 0.0;
      double totalY = 0.0;
      int starCount = 0;

      for (final star in constellationStars) {
        final double declinationRadians =
            star.parseDeclination(star.declination);
        final double rightAscensionRadians =
            star.parseRightAscension(star.rightAscension);

        final double x = circleRadius *
            math.cos(declinationRadians) *
            math.sin(rightAscensionRadians - observerLongitudeRadians);
        final double y = circleRadius *
            (math.sin(declinationRadians) * math.cos(observerLatitudeRadians) -
                math.cos(declinationRadians) *
                    math.sin(observerLatitudeRadians) *
                    math.cos(rightAscensionRadians - observerLongitudeRadians));

        double starX = center.dx + x;
        double starY = center.dy - y;
        starX = center.dx + (center.dx - starX);
        totalX += starX;
        totalY += starY;
        starCount++;

        final Paint starPaint = Paint()..color = Colors.white;
        double starRadius = 0.9 / zoomLevel;
        var parts = star.spectralClass.split(' ');
        if (parts[0].endsWith('I')) {
          starRadius = 3 / zoomLevel;
        }
        if (math.pow(starX - center.dx, 2) + math.pow(starY - center.dy, 2) <=
            math.pow(circleRadius, 2)) {
          canvas.drawCircle(Offset(starX, starY), starRadius, starPaint);
        }
      }

      double averageX = totalX / starCount;
      double averageY = totalY / starCount;
      _drawLabel(canvas, constellationStars[0].constellation,
          Offset(averageX, averageY));
    }
  }

 void _drawCompass(Canvas canvas, Offset center, double circleRadius) {
  final Paint linePaint = Paint()
    ..color = const Color.fromARGB(255, 64, 64, 64);

  canvas.drawLine(
    Offset(center.dx, center.dy - circleRadius),
    Offset(center.dx, center.dy + circleRadius),
    linePaint,
  );
  canvas.drawLine(
    Offset(center.dx - circleRadius, center.dy),
    Offset(center.dx + circleRadius, center.dy),
    linePaint,
  );

  const double labelOffset = 20.0;
  _drawLabel(canvas, 'N', Offset(center.dx, center.dy - circleRadius + labelOffset));
  _drawLabel(canvas, 'S', Offset(center.dx, center.dy + circleRadius - labelOffset));
  _drawLabel(canvas, 'E', Offset(center.dx - circleRadius + labelOffset, center.dy));
  _drawLabel(canvas, 'W', Offset(center.dx + circleRadius - labelOffset, center.dy));
}


  void _drawLabelSolarSystem(Canvas canvas, String text, Offset position) {
    const double offsetDistance = 10.0; 

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: Colors.white, fontSize: 14 / zoomLevel),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final double dx = position.dx - (textPainter.width / 2);
    final double dy = position.dy - (textPainter.height / 2);
    final double offsetX = dx + (offsetDistance / 2); 
    final double offsetY = dy + offsetDistance; 

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.rotate(-rotationAngle);
    canvas.translate(-offsetX, -offsetY);

    final Offset textOffset = Offset(offsetX, offsetY);
    textPainter.paint(canvas, textOffset);
    canvas.restore();
  }

  void _drawLabel(Canvas canvas, String text, Offset position) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(color: Colors.white, fontSize: 20 / zoomLevel),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  canvas.save();
  canvas.translate(position.dx, position.dy);
  canvas.rotate(-rotationAngle); // Ensure labels remain horizontal
  canvas.translate(-position.dx, -position.dy);

  final double dx = position.dx - (textPainter.width / 2);
  final double dy = position.dy - (textPainter.height / 2);
  textPainter.paint(canvas, Offset(dx, dy));
  canvas.restore();
}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
