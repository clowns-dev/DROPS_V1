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
    this.idNurse
  });

  factory Therapy.fromJson(Map<String, dynamic> json){
    return Therapy(
      idTherapy: json['idTherapy'],
      suggestedTime: json['suggestedTime'],
      extraTime: json['extraTime'],
      stretcherNumber: json['stretcherNumber'],
      startDate: json['startDate'],
      volume: json['volume'],
      finishDate: json['finishDate'],
      idPatient: json['idPatient'],
      idNurse: json['idNurse'],
    );
  }
}