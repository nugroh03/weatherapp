class WeatherModel {
  int? dt;
  Map? main;
  List? weather;
  Map? clouds;
  Map? wind;
  int? visibility;
  double? pop;
  Map? sys;
  String? dt_txt;

  WeatherModel({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.sys,
    this.dt_txt,

  });

  WeatherModel.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    main = json['main'];
    weather = json['weather'];
    clouds = json['clouds'];
    wind = json['wind'];
    visibility = json['visibility'];
    pop = double.tryParse(json['pop'].toString()) ;
    sys = json['sys'];
    dt_txt = json['dt_txt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'main': main,
      'weather': weather,
      'clouds': clouds,
      'wind': wind,
      'visibility': visibility,
      'pop': pop,
      'sys': sys,
      'dt_txt': dt_txt,
    };
  }
}
