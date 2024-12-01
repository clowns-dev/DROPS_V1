class Maintenance{
  final int? idBalance;
  final int? idUser;
  final double? lastFactor;
  final String? balanceCode;

  Maintenance({
    this.idBalance,
    this.idUser,
    this.lastFactor,
    this.balanceCode
  });

  factory Maintenance.fromJson(Map<String, dynamic> json){
    return Maintenance(
      idBalance: json['idBalance'],
      balanceCode: json['balanceCode']
    );
  }

  Map<String, dynamic> toJsonInsert() {
    return {
      'balance_id': idBalance,
      'user_id': idUser,
      'last_factor': lastFactor
    };
  }
}

