class Creneau {
  String? key;
  String? date;
  String? jourName;
  String? horaire;
  List<dynamic>? reserved;

  Creneau({this.key, this.date, this.jourName, this.horaire, this.reserved});

  Creneau.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    date = json['date'];
    jourName = json['jour_name'];
    horaire = json['horaire'];
    if (json['enfants'] != null) {
      reserved = [];
      json['enfants'].forEach((v) {
        if (v is Map<String, dynamic>) {
          reserved!.add(v);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['date'] = this.date;
    data['jour_name'] = this.jourName;
    data['horaire'] = this.horaire;
    if (this.reserved != null) {
      data['reserved'] = this.reserved!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
