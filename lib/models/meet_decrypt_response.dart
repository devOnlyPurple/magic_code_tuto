import 'meet.dart';

class MeetDecryptResponse {
  String? status;
  String? message;
  Meet? information;

  MeetDecryptResponse({this.status, this.message, this.information});

  MeetDecryptResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'] != null
        ? Meet.fromJson(json['information'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (information != null) {
      data['information'] = information!.toJson();
    }
    return data;
  }
}
