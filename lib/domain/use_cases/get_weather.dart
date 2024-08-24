import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

class GetWeather {
  final WeatherRepository repository;

  GetWeather(this.repository);

  Future<Map<String, List<Weather>>> call(double lat, double lon) {
    return repository.getWeather(lat, lon);
  }
}
