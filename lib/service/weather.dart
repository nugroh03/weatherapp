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

      var response = await http.get(
        Uri.parse(url),
        //headers: headers,
      );

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        WeathertoDayModel weather =
            WeathertoDayModel.fromJson(data as Map<String, dynamic>);

        return weather;
      } else {
        throw Exception('Gagal mengambil data cuaca');
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
      print("url" + url);

      var response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        List<dynamic> weather = data["list"];
        List<WeatherModel> newWeather = [];

        for (var item in weather) {
          newWeather.add(WeatherModel?.fromJson(item));
        }

        return newWeather;
      } else {
        throw Exception('Gagal mengambil data cuaca');
      }
    } on Exception catch (e) {
      print(e.toString());
      print("error");
      // TODO
    }
  }
}
