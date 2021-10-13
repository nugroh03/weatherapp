import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_app/constans.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/model/weathertoday_model.dart';
import 'package:weather_app/pages/first_page.dart';
import 'package:weather_app/service/weather.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widget/detailtoday.dart';
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
  String? tempCelcius;
  String? welcome;
  bool isLoading = true;
  String? notif = "Berhasil Masuk";
  List<String?>? listday = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String? notif = "Berhasil Masuk";
    String newcity = widget.city!.replaceAll("KABUPATEN ", "");
    newcity = newcity.replaceAll("KOTA ", "");
    getweathertoday(newcity);
    get5day(newcity);
  }

  void getweathertoday(city) {
    WeatherService().weathertoday(city).then((value) {
      if (value != null) {
        List<dynamic>? weee = value.weather;
        Map weather = weee![0];
        setState(() {
          weathertoday = value;
          getToday(weathertoday!.dt);
          //tempCelcius = (weathertoday!.main!["temp"] - 273.15).toStringAsFixed(2);
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.blueAccent,
              content: Text(
                notif!,
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => FirstPage()),
            (Route<dynamic> route) => false);
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                'Kota tidak ditemukan',
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
      }
    });
  }

  String greetingMessage() {
    var timeNow = DateTime.now().hour;
    if (timeNow <= 10) {
      return 'Selamat Pagi';
    } else if ((timeNow > 10) && (timeNow <= 15)) {
      return 'Selamat Siang';
    } else if ((timeNow > 15) && (timeNow < 18)) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  getToday(daynow) {
    final daynow1 = daynow; // timestamp in seconds
    final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(daynow1 * 1000);
    var format = new DateFormat('EEEE ,MMMM dd,yyyy ');
    // 'hh:mm' for hour & min
    var daynows = format.format(date1);
    var format2 = new DateFormat('hh');
    int toWelcome = int.parse(format2.format(date1));

    setState(() {
      dayNow = daynows.toString();
      tempCelcius = (weathertoday!.main!["temp"] - 273.15).toStringAsFixed(2);
      welcome = greetingMessage();
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
      Map newdays = {};
      List<WeatherModel?> dayss = [];
      WeatherModel getdt = value![0]!;
      int dt = getdt.dt!;
      String day = getDay(dt);
      listday!.add(day);

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
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 25),
        margin: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => FirstPage()),
                        (Route<dynamic> route) => false);
                  },
                  child: Icon(Icons.arrow_back_ios)),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Text(
                      widget.city.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(dayNow.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal))
                  ],
                ),
              ),
            ),
            Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isLoading = true;
                    String newcity = widget.city!.replaceAll("KABUPATEN ", "");
                    newcity = newcity.replaceAll("KOTA ", "");
                    notif = "Cuaca berhasil di perbarui";

                    getweathertoday(newcity);

                    get5day(newcity);

                    // Navigator.of(context).push(new MaterialPageRoute(
                    //     builder: (context) => SecondPage(
                    //           name: widget.name,
                    //           city: widget.city,
                    //         )));
                  });
                },
                child: Icon(
                  Icons.refresh,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget toDay() {
      return Container(
        padding: EdgeInsets.only(right: 30, left: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomRight,
                        height: 50,
                        child: Text(
                          '$welcome, ${widget.name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                      child: Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(tempCelcius!,
                                  style: TextStyle(fontSize: 55)),
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
            SizedBox(
              width: 20,
            ),
            Container(
              margin: EdgeInsets.only(right: 30),
              width: 120,
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
                child: Text(listday![index]!,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
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

    Widget buttonSheet() {
      return SizedBox.expand(
        child: DraggableScrollableSheet(
            initialChildSize: 0.12,
            minChildSize: 0.12,
            maxChildSize: 0.65,
            builder: (BuildContext c, s) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListView(
                  controller: s,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
                                    height: 10,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Center(
                                  child: Container(
                                      height: 40,
                                      child: Column(
                                        children: [
                                          Text("Geser ke atas",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white)),
                                          Text("Perkiraan Cuaca 5 Hari Kedepan",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white))
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
              );
            }),
      );
    }

    Widget detailToday() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Color(0xffCEE2F4), borderRadius: BorderRadius.circular(10)),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DetailToday(
                image: "assets/icon_humidity.png",
                value: weathertoday!.main!["humidity"].toString(),
                satuan: " %",
                title: "Humidity"),
            DetailToday(
                image: "assets/icon_pressure.png",
                value: weathertoday!.main!["pressure"].toString(),
                satuan: " hpa",
                title: "Pressure"),
            DetailToday(
                image: "assets/icon_cloudy.png",
                value: weathertoday!.clouds!["all"].toString(),
                satuan: " %",
                title: "Cloudiness"),
            DetailToday(
                image: "assets/icon_wind.png",
                value: weathertoday!.wind!["speed"].toString(),
                satuan: " m/s",
                title: "Wind"),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage("assets/bg.png"))),
          child: !isLoading
              ? Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                      child: header(), preferredSize: Size.fromHeight(80)),
                  body: Stack(children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          toDay(),
                          SizedBox(
                            height: 20,
                          ),
                          detailToday(),
                        ],
                      ),
                    ),
                    Positioned(child: buttonSheet())
                  ]))
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
