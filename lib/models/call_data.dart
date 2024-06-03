// ignore_for_file: public_member_api_docs, sort_constructors_first

class CallData {
  final String subject;
  final String serverUrl;
  final String room;
  final String jwt;
  CallData({
    required this.subject,
    required this.serverUrl,
    required this.room,
    required this.jwt,
  });

  factory CallData.fromMap(Map<String, dynamic> map) {
    return CallData(
      subject: map['subject'] as String,
      serverUrl: map['serverUrl'] as String,
      room: map['room'] as String,
      jwt: map['jwt'] as String,
    );
  }
}
