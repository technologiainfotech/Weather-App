import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/data/models/serializers.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/utils/api_constants.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(this.dio);

  Future<Map<String, List<WeatherModel>>> fetchWeather(
      double lat, double lon) async {
    final response = await dio.get(
      '${ApiConstants.baseURL}${ApiConstants.foreCast}',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': ApiConstants.appId,
      },
    );

    final data = response.data['list'];
    List<WeatherModel> weatherList = data
        .map((json) =>
            serializers.deserializeWith(WeatherModel.serializer, json))
        .toList()
        .cast<WeatherModel>();

    Map<String, List<WeatherModel>> groupedByDate = {};
    for (var weather in weatherList) {
      DateTime date = DateTime.parse(weather.dt_txt);
      String dateString = DateFormat('dd MMMM yyyy').format(date);

      if (groupedByDate.containsKey(dateString)) {
        groupedByDate[dateString]!.add(weather);
      } else {
        groupedByDate[dateString] = [weather];
      }
    }

    return groupedByDate;
  }
}
