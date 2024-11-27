class Therapy {
  final int? idTherapy;
  final int? suggestedTime;
  final int? extraTime;
  final String? stretcherNumber;
  final double? volume;
  final DateTime? startDate;
  final DateTime? finishDate;
  final int? status;
  final DateTime? registerDate;
  final int? userID;
  final int? idNurse;
  final int? idBalance;
  final int? idPerson;
  final String? ciNurse;
  final String? ciPatient;

  Therapy({
    this.idTherapy,
    this.suggestedTime,
    this.extraTime,
    this.stretcherNumber,
    this.volume,
    this.startDate,
    this.finishDate,
    this.status,
    this.registerDate,
    this.userID,
    this.idNurse,
    this.idBalance,
    this.idPerson,
    this.ciNurse,
    this.ciPatient,
  });

  factory Therapy.fromJson(Map<String, dynamic> json) {
    return Therapy(
      idTherapy: json['idTherapy'],
      suggestedTime: json['suggestedTime'],
      extraTime: json['extraTime'],
      stretcherNumber: json['stretcherNumber'],
      volume: json['volume'],
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      finishDate: json['finishDate'] != null ? DateTime.tryParse(json['finishDate']) : null,
      status: json['status'],
      registerDate: json['registerDate'] != null ? DateTime.tryParse(json['registerDate']) : null,
      idBalance: json['idBalance'],
      idPerson: json['idPerson'],
      ciNurse: json['ciNurse']?.toString(),
      ciPatient: json['ciPatient']?.toString(),
    );
  }
}

class Patient{
  final int? idPerson;
  final String? patient;
  final String? ci;

  Patient({
    this.idPerson,
    this.patient,
    this.ci
  });

  factory Patient.fromJson(Map<String, dynamic> json){
    return Patient(
      idPerson: json['idPatient'],
      patient: json['patient'],
      ci: json['ci'],
    );
  }
}

class Balance{
  final int? idBalance;
  final String? code;

  Balance({
    this.idBalance,
    this.code,
  });

  factory Balance.fromJson(Map<String, dynamic> json){
    return Balance(
      idBalance: json['idBalance'],
      code: json['code'],
    );
  }
}

class Nurse{
  final int? idNurse;
  final String? fullName;
  final String? ci;

  Nurse({
    this.idNurse,
    this.fullName,
    this.ci,
  });

  factory Nurse.fromJson(Map<String, dynamic> json){
    return Nurse(
      idNurse: json['idUser'],
      fullName: json['fullName'],
      ci: json['ci'],
    );
  }
}
class InfoTherapy{
  final int? idTherapy;
  final String? ciNurse;
  final String? ciPatient;
  final String? stretcherNumber;
  final DateTime? startDate;
  final DateTime? finishDate;
  final DateTime? startDateAssing;
  final DateTime? finishDateAssing;
  final int? idealTime;
  final int? totalTime;
  final double? volumen;
  final int? numberBubbles;
  final int? numberBlocks;
  final int? numberBoth;

  InfoTherapy({
    this.idTherapy,
    this.ciNurse,
    this.ciPatient,
    this.stretcherNumber,
    this.startDate,
    this.finishDate,
    this.startDateAssing,
    this.finishDateAssing,
    this.idealTime,
    this.totalTime,
    this.volumen,
    this.numberBubbles,
    this.numberBlocks,
    this.numberBoth
  });

  factory InfoTherapy.fromJson(Map<String, dynamic> json) {
    return InfoTherapy(
      idTherapy: json['idTherapy'],
      ciNurse: json['ciNurse']?.toString(),
      ciPatient: json['ciPatient']?.toString(),
      stretcherNumber: json['stretcherNumber']?.toString(),
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      finishDate: json['finishDate'] != null ? DateTime.tryParse(json['finishDate']) : null,
      startDateAssing: json['startDateAssing'] != null ? DateTime.tryParse(json['startDateAssing']) : null,
      finishDateAssing: json['finishDateAssing'] != null ? DateTime.tryParse(json['finishDateAssing']) : null,
      idealTime: json['idealTime'] != null ? int.tryParse(json['idealTime'].toString()) : null,
      totalTime: json['totalTime'] != null ? int.tryParse(json['totalTime'].toString()) : null,
      volumen: json['volumen'] != null ? double.tryParse(json['volumen'].toString()) : null,
      numberBubbles: json['numberBubbles'] != null ? int.tryParse(json['numberBubbles'].toString()) : null,
      numberBlocks: json['numberBlocks'] != null ? int.tryParse(json['numberBlocks'].toString()) : null,
      numberBoth: json['numberBoth'] != null ? int.tryParse(json['numberBoth'].toString()) : null,
    );
  }
}

class InfoTherapiesNurse{
  final int? idTherapy;
  final String? patient;
  final String? alert;
  final int? samplePercentage;
  final String? stretcherNumber;

  InfoTherapiesNurse({
    this.idTherapy,
    this.patient,
    this.alert,
    this.samplePercentage,
    this.stretcherNumber
  });

  factory InfoTherapiesNurse.fromJson(Map<String, dynamic> json){
    return InfoTherapiesNurse(
      idTherapy: json['idTherapy'],
      patient: json['patient'],
      alert: json['alert'],
      samplePercentage: int.tryParse(json['samplePercentage']),
      stretcherNumber: json['stretcherNumber']
    );
  }
}