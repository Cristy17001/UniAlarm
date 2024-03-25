import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherService {
  //14a77ed306894484876151151232305
  Future<Weather> getWeatherData() async{
    // Request location permission
    final locationPermission = await Geolocator.requestPermission();
    if (locationPermission != LocationPermission.denied) {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latitude = position.latitude;
      final longitude = position.longitude;

      final queryParameters = {
        'key' : '14a77ed306894484876151151232305',
        'q': '$latitude,$longitude',
      };
      final uri = Uri.http('api.weatherapi.com','/v1/current.json',queryParameters);
      final response = await http.get(uri);
      if(response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Cannot get weather");
      }
    } else {
      throw Exception("Location permission denied");
    }
  }
}


