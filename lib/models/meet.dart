class Meet {
  String? subject;
  String? serverUrl;
  String? room;
  String? jwt;

  Meet({this.subject, this.serverUrl, this.room, this.jwt});

  Meet.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    serverUrl = json['serverUrl'];
    room = json['room'];
    jwt = json['jwt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject'] = subject;
    data['serverUrl'] = serverUrl;
    data['room'] = room;
    data['jwt'] = jwt;
    return data;
  }
}
