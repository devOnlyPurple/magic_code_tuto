class About {
  String? logo;
  String? nomsociete;
  String? firstdes;
  String? version;
  String? contacts;
  String? email;
  String? siteweb;
  String? descapp;

  About(
      {this.logo,
      this.nomsociete,
      this.firstdes,
      this.version,
      this.contacts,
      this.email,
      this.siteweb,
      this.descapp});

  About.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    nomsociete = json['nomsociete'];
    firstdes = json['firstdes'];
    version = json['version'];
    contacts = json['contacts'];
    email = json['email'];
    siteweb = json['siteweb'];
    descapp = json['descapp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logo'] = logo;
    data['nomsociete'] = nomsociete;
    data['firstdes'] = firstdes;
    data['version'] = version;
    data['contacts'] = contacts;
    data['email'] = email;
    data['siteweb'] = siteweb;
    data['descapp'] = descapp;
    return data;
  }
}
