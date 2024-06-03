class Confirm {
  String? cinetApikey;
  String? cinetSiteId;
  String? notifyUrl;
  String? transactionId;
  String? amount;
  String? currency;
  String? channels;
  String? description;

  Confirm(
      {this.cinetApikey,
      this.cinetSiteId,
      this.notifyUrl,
      this.transactionId,
      this.amount,
      this.currency,
      this.channels,
      this.description});

  Confirm.fromJson(Map<String, dynamic> json) {
    cinetApikey = json['cinet_apikey'];
    cinetSiteId = json['cinet_site_id'];
    notifyUrl = json['notify_url'];
    transactionId = json['transaction_id'];
    amount = json['amount'].toString();
    currency = json['currency'];
    channels = json['channels'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cinet_apikey'] = cinetApikey;
    data['cinet_site_id'] = cinetSiteId;
    data['notify_url'] = notifyUrl;
    data['transaction_id'] = transactionId;
    data['amount'] = amount;
    data['currency'] = currency;
    data['channels'] = channels;
    data['description'] = description;
    return data;
  }
}
