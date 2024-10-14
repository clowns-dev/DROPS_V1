import 'package:ps3_drops_v1/models/patient.dart';

class Employee extends Patient {
  /// Propiedades adicionales de Employee
  final int? idEmployee;
  final String address;
  final dynamic phoneNumber;
  final String email;
  @override
  final DateTime? registerDate;
  String? rolName;
  final int? idPerson;

  /// Constructor de Employee
  Employee({
    this.idEmployee,
    required super.name,
    required super.lastName,
    required super.secondLastName,
    required super.birthDate,
    required super.ci,
    super.userID,
    required this.address,
    required this.phoneNumber,
    required this.email,
    this.registerDate,
    this.rolName,
    super.idPatient,
  })  : idPerson = idPatient;

  /// Mapeo a Json
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      idEmployee: json['idEmployee'],
      name: json['name'],
      lastName: json['lastName'],
      secondLastName: json['secondLastName'],
      birthDate: json['birthDate'],
      ci: json['ci'].toString(),
      userID: json['userID'],
      address: json['address'],
      phoneNumber: json['phoneNumber'].toString(),
      email: json['email'],
      rolName: json['rolName'],
      registerDate: json['registerDate'] != null ? DateTime.parse(json['registerDate']) : null,
    );
  }


}
