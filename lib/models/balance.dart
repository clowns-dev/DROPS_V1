class Balance {
  final int? idBalance;
  final String? balanceCode;
  final double? actuallyFactor;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? status;

  Balance({
    this.idBalance,
    this.balanceCode,
    this.actuallyFactor,
    this.registerDate,
    this.lastUpdate,
    this.status,
  });

  factory Balance.fromJson(Map<String, dynamic> json){
    return Balance(
      idBalance: json['idBalance'],
      balanceCode: json['balanceCode'],
      actuallyFactor: json['actuallyFactor'],
      registerDate: json['registerDate'] != null ? DateTime.parse(json['registerDate']) : null,
      lastUpdate: json['lastUpdate'] != null ? DateTime.parse(json['registerDate']) : null,
      status: json['status'],
    );
  }
}