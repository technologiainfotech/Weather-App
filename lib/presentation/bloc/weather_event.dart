part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final double lat;
  final double lon;

  const FetchWeather(this.lat, this.lon);

  @override
  List<Object> get props => [lat, lon];
}
