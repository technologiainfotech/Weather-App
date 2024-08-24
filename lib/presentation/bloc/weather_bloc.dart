import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/use_cases/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;

  WeatherBloc(this.getWeather) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  void _onFetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await getWeather(event.lat, event.lon);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(const WeatherError("Failed to fetch weather"));
      print(e);
    }
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) {
    try {
      final weather = (json['weather'] as List)
          .map((e) => Weather(
                date: e['date'],
                temperature: e['temperature'],
                description: e['description'],
              ))
          .toList();

      final weatherMap = <String, List<Weather>>{};
      for (var weather in weather) {
        DateTime date = DateTime.parse(weather.date);
        String dateString = DateFormat('dd MMMM yyyy').format(date);
        if (!weatherMap.containsKey(dateString)) {
          weatherMap[dateString] = [];
        }
        weatherMap[dateString]!.add(weather);
      }

      return WeatherLoaded(weatherMap);
    } catch (_) {
      return WeatherInitial();
    }
  }

  @override
  Map<String, dynamic> toJson(WeatherState state) {
    if (state is WeatherLoaded) {
      final weatherList = state.weather.entries
          .expand((entry) => entry.value.map((weather) => {
                'date': weather.date,
                'temperature': weather.temperature,
                'description': weather.description,
              }))
          .toList();

      return {
        'weather': weatherList,
      };
    }
    return {};
  }
}
