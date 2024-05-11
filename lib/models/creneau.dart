class Creneau {
  String? key;
  String? date;
  String? jourName;
  String? horaire;
  List<String>? reserved;

  Creneau({this.key, this.date, this.jourName, this.horaire, this.reserved});

  Creneau.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    date = json['date'];
    jourName = json['jour_name'];
    horaire = json['horaire'];
    if (json['reserved'] != null) {
      reserved = List<String>.from(json['reserved']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['date'] = this.date;
    data['jour_name'] = this.jourName;
    data['horaire'] = this.horaire;
    if (this.reserved != null) {
      data['reserved'] = List<String>.from(this.reserved!);
    }
    return data;
  }
}
