class Therapy {
  final int? idSmart;
  final String? codeRFID;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? status;

  Therapy({
    this.idSmart,
    this.codeRFID,
    this.registerDate,
    this.lastUpdate,
    this.status
  });

  factory Therapy.fromJson(Map<String, dynamic> json){
    return Therapy(
      idSmart: json['idSmart'],
      codeRFID: json['codeRFID'],
      registerDate: json['registerDate'] != null ? DateTime.parse(json['registerDate']) : null,
      lastUpdate: json['lastUpdate'] != null ? DateTime.parse(json['registerDate']) : null,
      status: json['status']
    );
  }
}