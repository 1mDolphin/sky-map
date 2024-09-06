import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;



class SensorProvider with ChangeNotifier {
  double _tiltAngle = 0;
  double _lastTiltAngle = 0;
  double _yaw = 0; 
  double _lastYaw = 0;

  SensorProvider() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
      double gX = event.x;
      double gY = event.y;
      double gZ = event.z;

      // Angle of inclination in radians
      double tilt = math.atan2(gZ, math.sqrt(gX * gX + gY * gY));

      // Smoothing slope values to avoid spikes
      _tiltAngle = _lastTiltAngle + (tilt - _lastTiltAngle) * 0.05; // Anti-aliasing coefficient 0.05
      _lastTiltAngle = _tiltAngle;

      notifyListeners();
    });
    });

    magnetometerEvents.listen((MagnetometerEvent event) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
      double x = event.x;
      double y = event.y;
      double yaw = math.atan2(y, x) * (180 / math.pi);   // Determining the yaw angle using a magnetic sensor
      if (yaw < 0) {                                     // Converting a value to a range from 0 to 360 degrees
        yaw += 360;
      }
      yaw = 360 - yaw;
     // Smoothing the values of the reed angle to avoid jumps
      _yaw = _lastYaw + (yaw - _lastYaw) * 0.05; // Anti-aliasing coefficient 0.05
      _lastYaw = _yaw;

      notifyListeners();
    });
    });
  }

  double get tiltAngle => _tiltAngle;
  double get yaw => _yaw;
}
