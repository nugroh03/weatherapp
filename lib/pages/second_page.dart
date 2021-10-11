import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:weather_app/constans.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/weathertoday_model.dart';
import 'package:weather_app/service/weather.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widget/listweather.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key, this.city, this.name}) : super(key: key);

  final String? city;
  final String? name;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  WeathertoDayModel? weathertoday;
  List<WeatherModel?>? weather5day;
  Map? days;
  String? dayNow;
  late String tempCelcius;
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
        getToday(weathertoday!.dt);
        //tempCelcius = (weathertoday!.main!["temp"] - 273.15).toStringAsFixed(2);
        isLoading = false;
      });
    });
  }

  getToday(daynow) {
    final daynow1 = daynow; // timestamp in seconds
    final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(daynow1 * 1000);
    var format =
        new DateFormat('EEEE ,MMMM dd,yyyy '); // 'hh:mm' for hour & min
    var daynows = format.format(date1);
    setState(() {
      dayNow = daynows.toString();
      tempCelcius = (weathertoday!.main!["temp"] - 273.15).toStringAsFixed(2);
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
    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Container(
              child: Icon(Icons.arrow_back_ios),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Text(widget.city.toString()),
                    Text(dayNow.toString())
                  ],
                ),
              ),
            ),
            Container(
              child: Icon(Icons.refresh),
            )
          ],
        ),
      );
    }

    Widget toDay() {
      return Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 140,
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.bottomCenter,
                        height: 50,
                        child: Text(
                          'Selamat Sore, ${widget.name}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(tempCelcius, style: TextStyle(fontSize: 50)),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "o",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "C",
                                      style: TextStyle(fontSize: 25),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 150,
              height: 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      alignment: Alignment.bottomRight,
                      height: 50,
                      child: Text(
                        weathertoday!.weather![0]['main'].toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Image.network(
                        "http://openweathermap.org/img/wn/${weathertoday!.weather![0]['icon']}@2x.png",
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget menuDay(index) {
      return Column(
        children: [
          Row(
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 60),
                child: Text(listday![index]!),
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(
                        children: days![listday![index]]
                            .map<Widget>((WeatherModel? item) {
                      final DateTime date1 =
                          DateTime.fromMillisecondsSinceEpoch(item!.dt! * 1000);
                      var format = new DateFormat('HH:mm');
                      var time = format.format(date1);
                      var image = item.weather![0]['icon'].toString();
                      var suhu =
                          (item.main!["temp"] - 273.15).toStringAsFixed(2);
                      return ListWeather(
                        time: time,
                        image: image,
                        suhu: suhu,
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
        ],
      );
    }

    return SafeArea(
      child: Scaffold(
        body: !isLoading
            ? SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      header(),
                      SizedBox(
                        height: 30,
                      ),
                      toDay(),
                      SizedBox(
                        height: 10,
                      ),
                      if (listday!.length > 0) menuDay(0),
                      SizedBox(
                        height: 10,
                      ),
                      if (listday!.length > 0) menuDay(1),
                      SizedBox(
                        height: 10,
                      ),
                      if (listday!.length > 0) menuDay(2),
                      SizedBox(
                        height: 10,
                      ),
                      if (listday!.length > 0) menuDay(3),
                      SizedBox(
                        height: 10,
                      ),
                      if (listday!.length > 0) menuDay(4)
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
