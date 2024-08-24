import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'weather_model.g.dart';

abstract class WeatherModel
    implements Built<WeatherModel, WeatherModelBuilder> {
  String get dt_txt;
  @BuiltValueField(wireName: 'main')
  Main get main;
  @BuiltValueField(wireName: 'weather')
  BuiltList<WeatherDescription> get weather;

  WeatherModel._();
  factory WeatherModel([void Function(WeatherModelBuilder) updates]) =
      _$WeatherModel;

  static Serializer<WeatherModel> get serializer => _$weatherModelSerializer;
}

abstract class Main implements Built<Main, MainBuilder> {
  double get temp;

  Main._();
  factory Main([void Function(MainBuilder) updates]) = _$Main;

  static Serializer<Main> get serializer => _$mainSerializer;
}

abstract class WeatherDescription
    implements Built<WeatherDescription, WeatherDescriptionBuilder> {
  String get description;

  WeatherDescription._();
  factory WeatherDescription(
          [void Function(WeatherDescriptionBuilder) updates]) =
      _$WeatherDescription;

  static Serializer<WeatherDescription> get serializer =>
      _$weatherDescriptionSerializer;
}
