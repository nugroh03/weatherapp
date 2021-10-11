import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/weathertoday_model.dart';
import 'package:weather_app/service/weather.dart';
import 'package:intl/intl.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key, this.city}) : super(key: key);

  final String? city;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  WeathertoDayModel? weathertoday;
  List<WeatherModel?>? weather5day;
  Map? days;
  bool isLoading = true;
  List<String?>? listday = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String newcity = widget.city!.replaceAll("KABUPATEN ", "");
    newcity = newcity.replaceAll("KOTA ", "");

    getweathertoday(newcity);
    get5day(newcity);
  }

  void getweathertoday(city) {
    WeatherService().weathertoday(city).then((value) {
      List<dynamic>? weee = value!.weather;
      Map weather = weee![0];
      setState(() {
        weathertoday = value;
        isLoading = false;
      });
    });
  }

  getDay(timestamp) {
    final timestamp1 = timestamp; // timestamp in seconds
    final DateTime date1 =
        DateTime.fromMillisecondsSinceEpoch(timestamp1 * 1000);
    var format = new DateFormat('EEEE'); // 'hh:mm' for hour & min
    var day = format.format(date1);
    return day;
  }

  void get5day(city) {
    WeatherService().weather5day(city).then((value) {
      //print("5days" + value.toString());

      Map newdays = {};
      List<WeatherModel?> dayss = [];
      WeatherModel getdt = value![0]!;
      int dt = getdt.dt!;
      String day = getDay(dt);
      listday!.add(day);
      print("dayss" + day);
      for (var i = 0; i < value.length; i++) {
        WeatherModel item = value[i]!;
        String timestamp = getDay(item.dt!);
        if (timestamp == day) {
          dayss.add(item);
        } else {
          dayss = [];
          day = timestamp;
          listday!.add(day);
          dayss.add(item);
        }
        newdays[timestamp] = dayss;
      }

      print("dayss" + newdays.toString());
      setState(() {
        weather5day = value;
        days = newdays;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: !isLoading
            ? Container(
                child: Column(
                  children: [
                    Text(weathertoday!.main!["temp"].toString()),
                    Container(
                      child: Column(
                        children: [
                          Text(weathertoday!.weather![0]['id'].toString())
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (listday!.length > 0)
                      Row(
                        children: [
                          Container(
                            child: Text(listday![0]!),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                child: Row(
                                    children: days![listday![0]]
                                        .map<Widget>((WeatherModel? item) {
                                  return Container(
                                    width: 100,
                                    child: Text(item!.dt!.toString()),
                                  );
                                }).toList()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    if (listday!.length > 0)
                      Row(
                        children: [
                          Container(
                            child: Text(listday![1]!),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                child: Row(
                                    children: days![listday![1]]
                                        .map<Widget>((WeatherModel? item) {
                                  final DateTime date1 =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          item!.dt! * 1000);
                                  var format = new DateFormat('HH:mm');
                                  var time = format.format(date1);
                                  return Container(
                                    width: 100,
                                    child: Column(
                                      children: [
                                        Text(time),
                                        Text(item.dt!.toString()),
                                        Text(item.main!["temp"].toString())
                                      ],
                                    ),
                                  );
                                }).toList()),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
