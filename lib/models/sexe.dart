class Sexe {
  String? key;
  String? name;

  Sexe({this.key, this.name});

  Sexe.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['name'] = name;
    return data;
  }
}
