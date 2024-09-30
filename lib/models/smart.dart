class Smart {
  final int? idSmart;
  final String? codeRFID;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? status;

  Smart({
    this.idSmart,
    this.codeRFID,
    this.registerDate,
    this.lastUpdate,
    this.status
  });

  factory Smart.fromJson(Map<String, dynamic> json){
    return Smart(
      idSmart: json['idSmart'],
      codeRFID: json['codeRFID'],
      registerDate: json['registerDate'] != null ? DateTime.parse(json['registerDate']) : null,
      lastUpdate: json['lastUpdate'] != null ? DateTime.parse(json['registerDate']) : null,
      status: json['status']
    );
  }
}