import 'package:http/http.dart' as http;
import 'dart:convert';

String encodeCredentials(String applicationId, String applicationSecret) {
  String userpass = '$applicationId:$applicationSecret';
  String authString = base64Encode(utf8.encode(userpass));
  return authString;
}

class SolarSystemService {
  static Future<Map<String, dynamic>> fetchSolarSystemData({
    required String latitude,
    required String longitude,
    required String elevation,
    required String fromDate,
    required String toDate,
    required String time,
    String output = 'table', // Default output format
  }) async {
    const baseUrl = 'https://api.astronomyapi.com/api/v2/bodies/positions';
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'latitude':  latitude, //'59.437323', //
      'longitude': longitude, // '24.765984', //
      'elevation': elevation, //'9.9'
      'from_date': fromDate,
      'to_date': toDate,
      'time': time,
    });
   
    final String authString = encodeCredentials(
        'd75010d8-b0f5-4f30-80ab-0cf1431bd721',
        '9e99284fb023d682ac6fa6504f09faa9284704f329c2ae8780d7dd2bc36f57a2f8b64cc39248ef6e64db40fbd9a7dd0979bdc9633197b07117b29365ff5903766dcaca823de8aa66b95323f8aa9d594af884ecea56a2132afab0f30d1c3010efa25279d15e0450dbd7cfcdf98a6d7747');

    final response = await http.get(uri, headers: {
      'Authorization': 'Basic $authString',
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load astronomy data: ${response.statusCode}');
    }
  }
}
