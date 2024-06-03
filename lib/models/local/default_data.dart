class DefaultData {
  String? langue;

  String? registrationId;
  String? deviceId;
  String? deviceName;

  DefaultData(
      {this.langue, this.registrationId, this.deviceId, this.deviceName});

  DefaultData.fromJson(Map<String, dynamic> json) {
    langue = json['langue'];

    registrationId = json['registration_id'];
    deviceId = json['devce_id'];
    deviceName = json['device_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['langue'] = langue;

    data['registration_id'] = registrationId;
    data['devce_id'] = deviceId;
    data['device_name'] = deviceName;
    return data;
  }
}
