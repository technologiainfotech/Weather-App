import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/utils/common_methods.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('weatherForeCast'.tr()),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            return Center(
              child: Text(
                'pleaseWait'.tr(),
              ),
            );
          } else if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final weatherMap = state.weather;
                final dates = weatherMap.keys.toList();
                final date = dates[index];
                final weatherList = weatherMap[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ...weatherList.map((weather) {
                      return ListTile(
                        leading:
                            CommonMethods.getWeatherIcon(weather.description),
                        title: Text(
                          CommonMethods.formatTime(weather.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          '${weather.temperature}°C - ${weather.description}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
              shrinkWrap: true,
              itemCount: state.weather.keys.length,
            );
          } else if (state is WeatherError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          CommonMethods.getLocationAndFetchWeather(context);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
