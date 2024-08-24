import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/use_cases/get_weather.dart';
import 'package:weather_app/presentation/bloc/weather_bloc.dart';

class MockGetWeather extends Mock implements GetWeather {}

class MockHydratedStorage extends Mock implements HydratedStorage {}

void main() {
  late MockGetWeather mockGetWeather;
  late MockHydratedStorage storage;

  setUp(() {
    mockGetWeather = MockGetWeather();
    storage = MockHydratedStorage();
    HydratedBloc.storage = storage;

    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
  });

  final mockWeather = {
    '2024-08-24': [
      Weather(date: '2024-08-24', temperature: 25, description: 'Sunny'),
    ]
  };

  group('WeatherBloc', () {
    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherLoaded] when FetchWeather is successful',
      setUp: () {
        when(() => mockGetWeather(any(), any()))
            .thenAnswer((_) async => mockWeather);
      },
      build: () => WeatherBloc(mockGetWeather),
      act: (bloc) => bloc.add(FetchWeather(37.7749, -122.4194)),
      expect: () => [
        WeatherLoading(),
        WeatherLoaded(mockWeather),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherError] when FetchWeather fails',
      setUp: () {
        when(() => mockGetWeather(any(), any())).thenThrow(Exception('error'));
      },
      build: () => WeatherBloc(mockGetWeather),
      act: (bloc) => bloc.add(FetchWeather(37.7749, -122.4194)),
      expect: () => [
        WeatherLoading(),
        const WeatherError('Failed to fetch weather'),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'correctly stores state when WeatherLoaded is emitted',
      setUp: () {
        when(() => storage.read(any())).thenReturn(null);
      },
      build: () => WeatherBloc(mockGetWeather),
      seed: () => WeatherLoaded(mockWeather),
      expect: () => [],
      verify: (_) {
        verify(() => storage.write('WeatherBloc', {
              'weather': [
                {
                  'date': '2024-08-24',
                  'temperature': 25,
                  'description': 'Sunny',
                }
              ]
            })).called(1);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'restores state from JSON correctly',
      setUp: () {
        when(() => storage.read(any())).thenReturn({
          'weather': [
            {
              'date': '2024-08-24',
              'temperature': 25,
              'description': 'Sunny',
            }
          ],
        });
      },
      build: () => WeatherBloc(mockGetWeather),
      seed: () => WeatherLoaded(mockWeather),
    );

    blocTest<WeatherBloc, WeatherState>(
      'returns WeatherInitial when JSON is invalid',
      setUp: () {
        when(() => storage.read(any()))
            .thenReturn({'invalid_key': 'invalid_value'});
      },
      build: () => WeatherBloc(mockGetWeather),
      verify: (bloc) {
        expect(bloc.state, WeatherInitial());
      },
    );
  });
}
