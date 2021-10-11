class WeathertoDayModel {
  Map? coord;
  List? weather;
  String? base;
  Map? main;
  int? visibility;
  Map? wind;
  Map? clouds;
  int? dt;
  int? timezone;
  int? id;
  String? name;
  int? cod;

  WeathertoDayModel({
    this.coord,
    this.weather,
    this.base,
    this.main,
    this.visibility,
    this.wind,
    this.clouds,
    this.dt,
     this.timezone,
    this.id,
    this.name,
     this.cod,
  });

  WeathertoDayModel.fromJson(Map<String, dynamic> json) {
    coord = json['coord'];
    weather = json['weather'];
    base = json['base'];
    main = json['main'];
    visibility = json['visibility'];
    wind = json['wind'];
    clouds = json['clouds'];
    dt = json['dt'];
    timezone = json['timezone'];
    id = json['id'];
    name = json['name'];
    cod = json['cod'];
  }

  Map<String, dynamic> toJson() {
    return {
      'coord': coord,
      'weather': weather,
      'base': base,
      'main': main,
      'visibility': visibility,
      'wind': wind,
      'clouds': clouds,
      'dt': dt,
      'timezone': timezone,
      'id': id,
      'name': name,
      'cod': cod,
    };
  }
}
