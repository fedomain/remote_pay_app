class Transaction {
  final String transactionId;
  final int transactionTypeId;
  final String userId;
  final num amount;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime dateTime;

  const Transaction ({
    required this.transactionId,
    required this.transactionTypeId,
    required this.userId,
    required this.amount,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    var lat = (json['latitude'] == null) ? 0.0 : json['latitude'] as double;
    var long = (json['longitude'] == null) ? 0.0 : json['longitude'] as double;

    return Transaction(
      transactionId: json['transactionId'] as String,
      transactionTypeId: json['transactionTypeId'] as int,
      userId: json['userId'] as String,
      amount: json['amount'] as num,
      description: json['description'] as String,
      latitude: lat,
      longitude: long,
      dateTime: DateTime.parse(json['datetime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'transactionTypeId': transactionTypeId,
      'userId': userId,
      'amount': amount,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'datetime': dateTime,
    };
  }

  @override
  String toString() => toJson().toString();
}
