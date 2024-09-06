import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/star_object.dart';


Future<List<StarObject>> fetchStarsInConstellation(String constellation) async {
  const String apiUrl = 'https://api.api-ninjas.com/v1/stars';
  const String apiKey = '+L/gJk1pFxF45IqlQhMbGQ==rtpQxeFrYfacShFX';
 // final Logger logger = Logger();

  try {
    final response = await http.get(
      Uri.parse('$apiUrl?constellation=$constellation'),
      headers: {
        'X-Api-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      //logger.i(data);
      return data.map((starJson) => StarObject.fromJson(starJson)).toList();
    } else {
      throw Exception('Failed to fetch star data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}




// [
//   {
//     "name": "Vega",
//     "constellation": "Lyra",
//     "right_ascension": "18h 36m 56.19s",
//     "declination": "+38° 46′ 58.8″",
//     "apparent_magnitude": "0.03",
//     "absolute_magnitude": "0.58",
//     "distance_light_year": "25",
//     "spectral_class": "A0Vvar"
//   }
// ]