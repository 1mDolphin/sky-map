import 'dart:math' as math;
import 'package:logger/logger.dart';

final Logger logger = Logger();

class StarObject {
  final String name;
  final String constellation;
  final String rightAscension;
  final String declination;
  final String apparentMagnitude;
  final String absoluteMagnitude;
  final int distanceLightYear;
  final String spectralClass;

  StarObject({
    required this.name,
    required this.constellation,
    required this.rightAscension,
    required this.declination,
    required this.apparentMagnitude,
    required this.absoluteMagnitude,
    required this.distanceLightYear,
    required this.spectralClass,
  });

  factory StarObject.fromJson(Map<String, dynamic> json) {
    return StarObject(
      name: json['name'],
      constellation: json['constellation'],
      rightAscension: json['right_ascension'],
      declination: json['declination'],
      apparentMagnitude: json['apparent_magnitude'],
      absoluteMagnitude: json['absolute_magnitude'],
      distanceLightYear: int.tryParse(json['distance_light_year'] ?? '') ?? 0,
      spectralClass: json['spectral_class'],
    );
  }

  // Перетворення екваторіальних координат у горизонтальні
  double parseDeclination(String declination) {
    try {
      // Remove non-breaking spaces before splitting
      final cleanedDeclination = declination.replaceAll(' ', '');
      final parts = cleanedDeclination.split(RegExp(r'°|′|″'));
      final sign = declination.startsWith('+') ? 1 : -1;
      final signAndDegrees = parts[0].replaceAll(RegExp(r'[^+\d-]'), '');
      final degrees = double.parse(signAndDegrees);
      final minutes = double.parse(parts[1]);
      final seconds = double.parse(parts[2]);
      final totalDegrees = degrees + minutes / 60 + seconds / 3600;
      return totalDegrees * sign * math.pi / 180;
    } catch (e) {
      logger.e('Error parsing declination: $e');
      return 0.0;
    }
  }

  double parseRightAscension(String rightAscension) {
    try {
      final parts = rightAscension.split(RegExp(r'[^\d.]+'));
      final hours = double.parse(parts[0]) * 15;
      final minutes = double.parse(parts[1]) * 0.25;
      final seconds = double.parse(parts[2]) * 0.00417;
      final totalHours = hours + minutes + seconds;
      return totalHours * math.pi / 180; // radians
    } catch (e) {
      logger.e('Error parsing right ascension: $e');
      return 0.0;
    }
  }
}
