 import 'package:flutter/material.dart';
 
    double getObjectRadius(String id) {
        switch (id) {
          case 'sun':
            return 14;
          case 'moon':
            return 8;
          case 'mars':
            return 6;
          case 'venus':
            return 6;
          case 'mercury':
            return 5;
          default:
            return 5;
        }
      }

    Paint getObjectPaint(String id) {
    switch (id) {
      case 'sun':
        return Paint()..color = Color.fromARGB(255, 247, 243, 5);
      case 'moon':
        return Paint()..color = Color.fromARGB(255, 224, 223, 223);
      case 'mars':
        return Paint()..color = const Color.fromARGB(255, 232, 8, 8);
      case 'venus':
        return Paint()..color = Color.fromARGB(255, 167, 81, 81);
      case 'mercury':
        return Paint()..color = Color.fromARGB(255, 178, 75, 75);
      default:
        return Paint()..color = Colors.blue;
    }
  }