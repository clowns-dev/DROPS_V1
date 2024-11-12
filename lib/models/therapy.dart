class Therapy {
  final int? idTherapy;
  final int? suggestedTime;
  final int? extraTime;
  final int? stretcherNumber;
  final DateTime? startDate;
  final double? volume;
  final DateTime? finishDate;
  final int? idPatient;
  final int? idNurse;

  Therapy({
    this.idTherapy,
    this.suggestedTime,
    this.extraTime,
    this.stretcherNumber,
    this.startDate,
    this.volume,
    this.finishDate,
    this.idPatient,
    this.idNurse,
  });

  factory Therapy.fromJson(Map<String, dynamic> json) {
    return Therapy(
      idTherapy: json['idTherapy'],
      suggestedTime: json['suggestedTime'],
      extraTime: json['extraTime'],
      stretcherNumber: json['stretcherNumber'],
      startDate: DateTime.parse(json['startDate']), // Conversión de String a DateTime
      volume: json['volume'] != null ? json['volume'].toDouble() : null, // Conversión de número a double
      finishDate: DateTime.parse(json['finishDate']), // Conversión de String a DateTime
      idPatient: json['idPatient'],
      idNurse: json['idNurse'],
    );
  }
}
