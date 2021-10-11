import 'package:flutter/material.dart';

class ListWeather extends StatelessWidget {
  const ListWeather({Key? key, this.time, this.suhu, this.image})
      : super(key: key);

  final String? time;
  final String? suhu;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(time!),
          Container(
            height: 40,
            width: 40,
            child: Image.network(
                "http://openweathermap.org/img/wn/${image!}@2x.png"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(suhu!),
              SizedBox(
                width: 5,
              ),
              Container(
                padding: EdgeInsets.only(top: 2),
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'o',
                      style: TextStyle(fontSize: 8),
                    ),
                    Text(
                      'C',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
    ;
  }
}
