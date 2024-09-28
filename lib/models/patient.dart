class Patient {
  ///Propiedades
  final int? idPatient;
  final String name;
  final String lastName;
  final String secondLastName;
  final String birthDate;
  final String ci;
  final DateTime? lastUpdate;
  final int? userID;

  ///Constructor
  Patient({
    this.idPatient,
    required this.name,
    required this.lastName,
    required this.secondLastName,
    required this.birthDate,
    required this.ci,
    this.lastUpdate,
    this.userID
  });
  
  ///Mapeo a Json
  factory Patient.fromJson(Map<String, dynamic> json){
    return Patient(
      idPatient: json['idPatient'],
      name: json['name'],
      lastName: json['lastName'],
      secondLastName: json['secondLastName'],
      birthDate: json['birthDate'],
      ci: json['ci'],
      userID: json['userID']
    );
  }
}