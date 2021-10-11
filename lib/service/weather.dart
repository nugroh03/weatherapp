import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/api.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/weathertoday_model.dart';

class WeatherService {
  Future<WeathertoDayModel?> weathertoday(city) async {
    try {
      var url = "$apiWeather$city&appid=acdb717ff54b01b8ff06f47a7440103d";
      //var headers = {'Content-Type': 'aplication/json'};
      print("url" + url);

      var response = await http.get(
        Uri.parse(url),
        //headers: headers,
      );

      print(response.body);

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        //print("data" + data.toString());
        WeathertoDayModel weather =
            WeathertoDayModel.fromJson(data as Map<String, dynamic>);

        // for (var item in data) {
        //   weather.add(WeatherModel?.fromJson(item));
        // }
        //print("weather" + weather.toString());
        return weather;
      } else {
        throw Exception('Gagal Get News');
      }
    } on Exception catch (e) {
      print(e.toString());
      print("error");
      // TODO
    }
  }

  Future<List<WeatherModel?>?> weather5day(city) async {
    try {
      var url = "$api5day$city&appid=acdb717ff54b01b8ff06f47a7440103d";
      //var headers = {'Content-Type': 'aplication/json'};
      print("url" + url);

      var response = await http.get(
        Uri.parse(url),
        //headers: headers,
      );


      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        List<dynamic> weather = data["list"];
        List<WeatherModel> newWeather = [];

        for (var item in weather) {
        newWeather.add(WeatherModel?.fromJson(item));
      }

       
        // for (var item in data) {
        //   weather.add(WeatherModel?.fromJson(item));
        // }
        print("5day" + newWeather.toString());
        return newWeather;
      } else {
        throw Exception('Gagal Get News');
      }
    } on Exception catch (e) {
      print(e.toString());
      print("error");
      // TODO
    }
  }

}