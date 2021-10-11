class RegenciesModel {
  String? id;
  String? province_id;
  String? name;
 

  RegenciesModel({
    this.id,
    this.province_id,
    this.name,
   
  });

  RegenciesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    province_id = json['province_id'];
    name = json['name'];
  
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'province_id': province_id,
      'name': name,
     
    };
  }
}
