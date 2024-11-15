import 'package:flutter/foundation.dart';
import 'package:ps3_drops_v1/models/patient.dart' as PatientModel;
import 'package:ps3_drops_v1/models/nurse.dart' as NurseModel;
import 'package:ps3_drops_v1/models/balance.dart' as BalanceModel;
import 'package:ps3_drops_v1/models/therapy.dart' as TherapyModel;
import 'package:ps3_drops_v1/services/api_service_therapy.dart';

class TherapyViewModel extends ChangeNotifier {
  final ApiServiceTherapy apiServiceTherapy = ApiServiceTherapy();

  List<TherapyModel.Therapy> listTherapies = [];
  List<TherapyModel.Therapy> filteredTherapies = [];
  TherapyModel.InfoTherapy? infoTherapy;
  int? selectedTherapyId;

  List<PatientModel.Patient> listPatients = [];
  int? selectedPatientId;

  List<NurseModel.Nurse> listNurses = [];
  int? selectedNurseId;

  List<BalanceModel.Balance> listBalances = [];
  int? selectedBalanceId;

  bool isLoading = false;

  TherapyViewModel() {
    fetchAllData();
  }

  void fetchAllData() {
    fetchTherapies();
    fetchTherapyPatients();
    fetchTherapyNurses();
    fetchTherapyBalances();
  }

  Future<void> fetchTherapies() async {
    _setLoading(true);
    try {
      listTherapies = await apiServiceTherapy.fetchTherapies();
      filteredTherapies = List.from(listTherapies);
    } catch (e) {
      print('Error al obtener los registros de Terapias: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTherapyPatients() async {
    _setLoading(true);
    try {
      listPatients = await apiServiceTherapy.fetchTherapyPatients();
    } catch (e) {
      print('Error al obtener los registros de Pacientes: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTherapyNurses() async {
    _setLoading(true);
    try {
      listNurses = await apiServiceTherapy.fetchTherapyNurses();
    } catch (e) {
      print('Error al obtener los registros de Enfermeros: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTherapyBalances() async {
    _setLoading(true);
    try {
      listBalances = await apiServiceTherapy.fetchTherapyBalances();
    } catch (e) {
      print('Error al obtener los registros de Balanzas: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchInfoTherapy(int therapyId) async {
    _setLoading(true);
    try {
      infoTherapy = await apiServiceTherapy.fetchInfoTherapy(therapyId);
    } catch (e) {
      print("Error al obtener la información de la Terapia: $e");
    } finally {
      _setLoading(false);
    }
  }

  void updateSelectedPatientId(int id) {
    selectedPatientId = id;
    notifyListeners();
  }

  void updateSelectedNurseId(int id) {
    selectedNurseId = id;
    notifyListeners();
  }

  void updateSelectedBalanceId(int id) {
    selectedBalanceId = id;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
