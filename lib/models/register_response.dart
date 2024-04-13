class ResponseSignup {
  String? status;
  String? resetPass;
  String? uIdentifiant;
  String? message;

  ResponseSignup(
      {this.status, this.resetPass, this.uIdentifiant, this.message});

  ResponseSignup.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    resetPass = json['reset_pass'];
    uIdentifiant = json['u_identifiant'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['reset_pass'] = resetPass;
    data['u_identifiant'] = uIdentifiant;
    data['message'] = message;
    return data;
  }
}
