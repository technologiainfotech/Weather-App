import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/presentation/pages/weather_page.dart';

import 'weather_bloc_test.dart';

class MockHydratedStorage extends Mock implements HydratedStorage {
  @override
  Future<void> write(String key, dynamic value) async {
    return Future.value();
  }
}

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    late HydratedStorage storage;

    storage = MockHydratedStorage();
    HydratedBloc.storage = storage;
  });

  testWidgets('WeatherPage displays weather data', (WidgetTester tester) async {
    final weatherBloc = WeatherBloc(MockGetWeather());
    weatherBloc.emit(
      WeatherLoaded(
        {
          '2023-10-01': [
            Weather(
              date: '2023-10-01',
              temperature: 20.0,
              description: 'Clear sky',
            ),
          ],
        },
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WeatherBloc>(
          create: (_) => weatherBloc,
          child: const WeatherPage(),
        ),
      ),
    );

    expect(find.text('2023-10-01'), findsOneWidget);
    expect(find.text('20.0°C - Clear sky'), findsOneWidget);
  });
}
