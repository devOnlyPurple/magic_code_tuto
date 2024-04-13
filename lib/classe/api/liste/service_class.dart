class Services {
  String? designation;
  String? description;
  String? serviceKey;
  String? serviceImage;
  int? servicePrixHoraire;
  String? servicePrixHoraireShow;
  int? servicePrixDay;
  String? servicePrixDayShow;

  Services(
      {this.designation,
      this.description,
      this.serviceKey,
      this.serviceImage,
      this.servicePrixHoraire,
      this.servicePrixHoraireShow,
      this.servicePrixDay,
      this.servicePrixDayShow});

  Services.fromJson(Map<String, dynamic> json) {
    designation = json['designation'];
    description = json['description'];
    serviceKey = json['service_key'];
    serviceImage = json['service_image'];
    servicePrixHoraire = json['service_prix_horaire'];
    servicePrixHoraireShow = json['service_prix_horaire_show'];
    servicePrixDay = json['service_prix_day'];
    servicePrixDayShow = json['service_prix_day_show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['designation'] = designation;
    data['description'] = description;
    data['service_key'] = serviceKey;
    data['service_image'] = serviceImage;
    data['service_prix_horaire'] = servicePrixHoraire;
    data['service_prix_horaire_show'] = servicePrixHoraireShow;
    data['service_prix_day'] = servicePrixDay;
    data['service_prix_day_show'] = servicePrixDayShow;
    return data;
  }
}