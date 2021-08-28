import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/data/repository/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherLoading());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    // TODO: implement mapEventToState
    WeatherRepository weatherRepository = WeatherRepository();
    if (event is LoadWeather) {
      yield WeatherLoading();
      List<Weather> weatherList = await weatherRepository.getWeatherData();
      List<Weather> temp = [];
      for (var i = 0; i < weatherList.length - 1; i++) {
        if (weatherList[i].day != weatherList[i + 1].day) {
          temp.add(weatherList[i]);
        }
      }
      weatherList = temp;

      yield WeatherLoaded(weatherData: weatherList);
    } else if (event is LoadFilteredWeather) {
      String day = event.day;
      print(day);
      List<Weather> weatherList = await weatherRepository.getWeatherData();
      List<Weather> temp = [];
      for (var i = 0; i < weatherList.length - 1; i++) {
        if (weatherList[i].day == day) {
          temp.add(weatherList[i]);
        }
      }
      weatherList = temp;
      print('omo${weatherList.first.city}');
      yield WeatherFilteredData(weatherDayData: weatherList);
    }
  }
}
