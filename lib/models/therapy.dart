import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Therapy {
  final int? idTherapy;
  final int? suggestedTime;
  final int? extraTime;
  final int? stretcherNumber; // Cambiado a int para coincidir con el JSON
  final double? volume;
  final DateTime? startDate;
  final DateTime? finishDate;
  final int? status;
  final DateTime? registerDate;
  final int? userID;
  final int? idBalance;
  final int?
      idPatient; // Cambiado de idPerson a idPatient para coincidir con el JSON
  final int?
      idNurse; // Cambiado de ciNurse a idNurse para coincidir con el JSON

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
    this.idBalance,
    this.idPatient,
    this.idNurse,
  });

  factory Therapy.fromJson(Map<String, dynamic> json) {
    return Therapy(
      idTherapy: json['idTherapy'],
      suggestedTime: json['suggestedTime'],
      extraTime: json['extraTime'],
      stretcherNumber: json['stretcherNumber'],
      volume: json['volume'],
      startDate: _parseDate(json['startDate']),
      finishDate: _parseDate(json['finishDate']),
      status: json['status'],
      registerDate: _parseDate(json['registerDate']),
      idBalance: json['idBalance'],
      idPatient: json['idPatient'],
      idNurse: json['idNurse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTherapy': idTherapy,
      'suggestedTime': suggestedTime,
      'extraTime': extraTime,
      'stretcherNumber': stretcherNumber,
      'volume': volume,
      'startDate': startDate?.toIso8601String(),
      'finishDate': finishDate?.toIso8601String(),
      'status': status,
      'registerDate': registerDate?.toIso8601String(),
      'userID': userID,
      'idBalance': idBalance,
      'idPatient': idPatient,
      'idNurse': idNurse,
    };
  }

  static DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;

    try {
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateString, true);
    } catch (e) {
      if (kDebugMode) {
        print("Error al parsear la fecha: $dateString");
      }
      return null;
    }
  }

  // Método para calcular el tiempo total en minutos entre inicio y fin de la terapia
  int? getTotalTime() {
    if (startDate != null && finishDate != null) {
      return finishDate!.difference(startDate!).inMinutes;
    }
    return null;
  }
}

class InfoTherapy {
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
    this.numberBoth,
  });

  factory InfoTherapy.fromJson(Map<String, dynamic> json) {
    return InfoTherapy(
      idTherapy: json['idTherapy'],
      ciNurse: json['ciNurse']?.toString(),
      ciPatient: json['ciPatient']?.toString(),
      stretcherNumber: json['stretcherNumber']?.toString(),
      startDate: Therapy._parseDate(json['startDate']),
      finishDate: Therapy._parseDate(json['finishDate']),
      startDateAssing: Therapy._parseDate(json['startDateAssing']),
      finishDateAssing: Therapy._parseDate(json['finishDateAssing']),
      idealTime: json['idealTime'] != null
          ? int.tryParse(json['idealTime'].toString())
          : null,
      totalTime: json['totalTime'] != null
          ? int.tryParse(json['totalTime'].toString())
          : null,
      volumen: json['volumen'] != null
          ? double.tryParse(json['volumen'].toString())
          : null,
      numberBubbles: json['numberBubbles'] != null
          ? int.tryParse(json['numberBubbles'].toString())
          : null,
      numberBlocks: json['numberBlocks'] != null
          ? int.tryParse(json['numberBlocks'].toString())
          : null,
      numberBoth: json['numberBoth'] != null
          ? int.tryParse(json['numberBoth'].toString())
          : null,
    );
  }

  int? getTotalTime() {
    if (startDate != null && finishDate != null) {
      return finishDate!.difference(startDate!).inMinutes;
    }
    return null;
  }

  Map<String, double> calculateTimePercentages() {
    int totalTime = this.totalTime ?? getTotalTime() ?? 1;
    return {
      "Operativo": (totalTime -
              (numberBubbles ?? 0) -
              (numberBlocks ?? 0) -
              (numberBoth ?? 0)) /
          totalTime *
          100,
      "Interrupción por Burbuja": (numberBubbles ?? 0) / totalTime * 100,
      "Interrupción por Bloqueo": (numberBlocks ?? 0) / totalTime * 100,
      "Tiempo Prolongado": (numberBoth ?? 0) / totalTime * 100,
    };
  }
}

class Patient {
  final int? idPatient;
  final String name;
  final String lastName;
  final String? secondLastName;
  final DateTime? birthDate;
  final String ci;
  final int? status;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? userID;

  Patient(
      {this.idPatient,
      required this.name,
      required this.lastName,
      this.secondLastName,
      required this.birthDate,
      required this.ci,
      this.status,
      this.registerDate,
      this.lastUpdate,
      this.userID});

  factory Patient.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormatWithGMT =
        DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    DateFormat dateFormatWithoutGMT = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;

      try {
        return dateFormatWithGMT.parse(dateString);
      } catch (e) {
        try {
          return dateFormatWithoutGMT.parse(dateString);
        } catch (e) {
          if (kDebugMode) {
            print("Error al parsear la fecha: $dateString");
          }
          return null;
        }
      }
    }

    return Patient(
        idPatient: json['idPatient'],
        name: json['name'],
        lastName: json['lastName'],
        secondLastName: json['secondLastName'] ?? 'No tiene',
        birthDate:
            json['birthDate'] != null ? parseDate(json['birthDate']) : null,
        ci: json['ci'],
        status: json['status'],
        registerDate: parseDate(json['registerDate']),
        lastUpdate:
            json['lastUpdate'] != null && json['lastUpdate'] != "Sin Cambios"
                ? parseDate(json['lastUpdate'])
                : null,
        userID: json['userID']);
  }
}
