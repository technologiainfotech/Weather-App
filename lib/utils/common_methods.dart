import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';

class CommonMethods {
  static Future<void> getLocationAndFetchWeather(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    // When permissions are granted, get the current position
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    context
        .read<WeatherBloc>()
        .add(FetchWeather(position.latitude, position.longitude));
  }

  static Icon getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return const Icon(Icons.wb_sunny, color: Colors.orange);
      case 'few clouds':
        return const Icon(Icons.cloud, color: Colors.grey);
      case 'scattered clouds':
        return const Icon(Icons.cloud_queue, color: Colors.grey);
      case 'broken clouds':
        return Icon(Icons.cloud, color: Colors.grey[700]);
      case 'shower rain':
        return const Icon(Icons.grain, color: Colors.blue);
      case 'rain':
        return const Icon(Icons.beach_access, color: Colors.blue);
      case 'thunderstorm':
        return const Icon(Icons.flash_on, color: Colors.yellow);
      case 'snow':
        return const Icon(Icons.ac_unit, color: Colors.lightBlue);
      case 'mist':
        return const Icon(Icons.blur_on, color: Colors.grey);
      default:
        return const Icon(Icons.wb_cloudy, color: Colors.grey);
    }
  }

  static String formatTime(String dtTxt) {
    DateTime date = DateTime.parse(dtTxt);
    return DateFormat('HH:mm a').format(date);
  }
}
