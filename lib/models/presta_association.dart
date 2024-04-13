class Associations {
  String? name;
  String? poste;

  Associations({this.name, this.poste});

  Associations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    poste = json['poste'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['poste'] = this.poste;
    return data;
  }
}