import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future<Position> _getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied.');
  }

  return await Geolocator.getCurrentPosition();
}

Future<void> sendSos(String token) async {
  try {
    final position = await _getCurrentLocation();

    final response = await http.post(
      Uri.parse('https://yourapi.com/api/sos/trigger'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'location': {
          'coordinates': [position.longitude, position.latitude],
        },
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      print("SOS triggered successfully");
    } else {
      // Error
      print("Failed: ${response.body}");
    }
  } catch (e) {
    print("Error: $e");
  }
}