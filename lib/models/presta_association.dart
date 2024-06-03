class Associations {
  String? name;
  String? poste;

  Associations({this.name, this.poste});

  Associations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    poste = json['poste'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['poste'] = poste;
    return data;
  }
}