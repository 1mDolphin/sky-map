import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../screens/home_screen.dart';
import '../providers/celestial_object_provider.dart'; 
import '../providers/location_provider.dart'; 
import '../providers/sensor_provider.dart'; 


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => CelestialObjectsProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}
