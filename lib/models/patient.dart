import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Patient {
  ///Propiedades
  final int? idPatient;
  final String name;
  final String lastName;
  final String? secondLastName;
  final DateTime? birthDate;
  final String ci;
  final String? genre;
  final int? status;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? userID;

  ///Constructor
  Patient({
    this.idPatient,
    required this.name,
    required this.lastName,
    this.secondLastName,
    required this.birthDate,
    required this.ci,
    this.genre,
    this.status,
    this.registerDate,
    this.lastUpdate,
    this.userID
  });
  
  ///Mapeo a Json
  factory Patient.fromJson(Map<String, dynamic> json){
    DateFormat dateFormatWithGMT = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    DateFormat dateFormatWithoutGMT = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime? parseDate(String? dateString){
      if(dateString == null) return null;

      try{
        return dateFormatWithGMT.parse(dateString);
      } catch (e){
        try{
          return dateFormatWithoutGMT.parse(dateString);
        } catch (e){
          if (kDebugMode){
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
      birthDate: json['birthDate'] != null
                  ? parseDate(json['birthDate'])
                  : null,
      ci: json['ci'],
      genre: json['genre'],
      status: json['status'],
      registerDate: parseDate(json['registerDate']),
      lastUpdate: json['lastUpdate'] != null && json['lastUpdate'] != "Sin Cambios"
                  ? parseDate(json['lastUpdate'])
                  : null,
      userID: json['userID']
    );
  }
}