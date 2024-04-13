class MenuSpecialResponse {
  String? status;
  String? message;
  String? information;

  MenuSpecialResponse({this.status, this.message, this.information});

  MenuSpecialResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['information'] = information;
    return data;
  }
}
