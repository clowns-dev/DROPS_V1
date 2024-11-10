import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class User {
  ///Propiedades
  final int? idUser;
  final String? name;
  final String? lastName;
  final String? secondLastName;
  final String? phone;
  final String? email;
  final String? address;
  final DateTime? birthDate;
  final String? genre;
  final String? ci;
  final int? status;
  String? nameRole;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? idRole;

  ///Constructor
  User({
    this.idUser,
    this.name,
    this.lastName,
    this.secondLastName,
    this.phone,
    this.email,
    this.address,
    this.birthDate,
    this.genre,
    this.ci,
    this.status,
    this.nameRole,
    this.registerDate,
    this.lastUpdate,
    this.idRole
  });
  
  ///Mapeo a Json
  factory User.fromJson(Map<String, dynamic> json){
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

    return User(
      idUser: json['idUser'],
      name: json['name'],
      lastName: json['lastName'],
      secondLastName: json['secondLastName'] ?? 'No tiene',
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      birthDate: json['birthDate'] != null
                  ? parseDate(json['birthDate'])
                  : null,
      genre: json['genre'],
      ci: json['ci'],
      status: json['status'],
      nameRole: json['nameRole'],
      registerDate: parseDate(json['registerDate']),
      lastUpdate: json['lastUpdate'] != null && json['lastUpdate'] != "Sin Cambios"
                  ? parseDate(json['lastUpdate'])
                  : null,
      idRole: json['idRole']
    );
  }

  Map<String, dynamic> toJsonInsert() {
    return {
      'name': name,
      'last_name': lastName,
      'second_last_name': secondLastName,
      'phone': phone,
      'email': email,
      'address': address,
      'birth_date': birthDate,
      'genre': genre,
      'ci': ci,
      'role_id': idRole
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      'user_id': idUser,
      'name': name,
      'last_name': lastName,
      'second_last_name': secondLastName,
      'phone': phone,
      'email': email,
      'address': address,
      'birth_date': birthDate,
      'genre': genre,
      'ci': ci,
      'role_id': idRole
    };
  }
}