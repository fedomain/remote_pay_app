class TopUp {
  final String topUpId;
  final String userId;
  final num amount;
  final String? currency;
  final num? exchangeRate;
  final num? amountInRmb;
  final DateTime dateTime;

  const TopUp ({
    required this.topUpId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.exchangeRate,
    required this.amountInRmb,
    required this.dateTime,
  });

  factory TopUp.fromJson(Map<String, dynamic> json) {
    return TopUp(
      topUpId: json['topUpId'] as String,
      userId: json['userId'] as String,
      amount: json['amount'] as num,
      currency: json['currency'] as String?,
      exchangeRate: json['exchangeRate'] as num?,
      amountInRmb: json['amountInRmb'] as num?,
      dateTime: DateTime.parse(json['datetime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topUpId': topUpId,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'exchangeRate': exchangeRate,
      'amountInRmb': amountInRmb,
      'dateTime': dateTime,
    };
  }

  @override
  String toString() => toJson().toString();
}