class Smart {
  final int idSmart;
  final String codeRFID;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? status;

  Smart({
    required this.idSmart,
    required this.codeRFID,
    this.registerDate,
    this.lastUpdate,
    this.status
  });

  factory Smart.fromJson(Map<String, dynamic> json){
    return Smart(
      idSmart: json['idSmart'],
      codeRFID: json['codeRFID'],
      registerDate: json['registerDate'],
      lastUpdate: json['lastUpdate'],
      status: json['status']
    );
  }
}