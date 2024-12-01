import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ps3_drops_v1/models/maintenance.dart';
import 'package:ps3_drops_v1/services/api_middleware.dart';
import 'package:ps3_drops_v1/services/api_service_maintenance.dart';
import 'package:ps3_drops_v1/services/mqtt_service.dart';

class MaintenanceViewModel extends ChangeNotifier {
  final ApiMiddleware _apiMiddleware = ApiMiddleware();
  late final ApiServiceMaintenance apiServiceMaintenance = ApiServiceMaintenance(_apiMiddleware);
  final MqttService mqttService = MqttService();

  String _receivedPeso = 'Esperando valores...';
  String _receivedFactor = 'Esperando valores...';
  bool _isConnected = false;

  String get receivedPeso => _receivedPeso;
  String get receivedFactor => _receivedFactor;
  bool get isConnected => _isConnected;

  MaintenanceViewModel(){
    _initializeMqtt();
  }

  Future<void> _initializeMqtt() async {
    await mqttService.connect();
    _isConnected = mqttService.isConnected;
    notifyListeners();

    mqttService.listenToMessages((topic, payload) {
        if(topic.contains('parametros')){
          final data = payload.split(',');
          _receivedPeso = data[0];
          _receivedFactor = data[1];
          notifyListeners();
        }
      });
  }

 

  Future<void> subscribeToBalance(String balanceCode) async {
    if (balanceCode.isNotEmpty) {
      final topic = 'drops/calibra/$balanceCode/parametros';
      mqttService.subscribe(topic);
      if (kDebugMode) {
        print('Suscrito al tópico: $topic');
      }

      final publishTopic = 'drops/calibra/$balanceCode';
      const message = 'true';
      mqttService.publish(publishTopic, message);
    } else {
      if (kDebugMode) {
        print('Error: El código de la balanza está vacío.');
      }
    }
  }

  Future<void> publishNewFactor(String balanceCode, String newFactor) async {
    if (balanceCode.isNotEmpty && newFactor.isNotEmpty) {
      final topic = 'drops/calibra/$balanceCode/ajuste';
      mqttService.publish(topic, newFactor);
      if (kDebugMode) {
        print('Nuevo Factor publicado: $newFactor');
      }
    } else {
      if (kDebugMode) {
        print('Error: Faltan datos para publicar el factor.');
      }
    }
  }

  void disconnectMqtt(String balanceCode) {
    if(balanceCode.isNotEmpty){
      final topicConcluirMessage = 'drops/calibra/$balanceCode';
      const message = 'false';
      mqttService.publish(topicConcluirMessage, message);
      mqttService.disconnect();
      _isConnected = mqttService.isConnected;
      notifyListeners();
    }
  }

  Future<Maintenance?> fetchBalanceId(BuildContext context,String balanceCode) async {
    Maintenance? maintenance;
    try {
      maintenance = await apiServiceMaintenance.fetchBalanceIdByCode(context,balanceCode);
      if (kDebugMode) {
        print('Balanza cargada: $maintenance');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener el ID de la balanza: $e');
      }
    } finally {
      notifyListeners();
    }
    return maintenance;
  }

  Future<void> createNewMaintenance(BuildContext context, Maintenance newMaintenance) async {
    try {
      if (newMaintenance.idBalance != null &&
          newMaintenance.idUser != null &&
          newMaintenance.lastFactor != null) {
        await apiServiceMaintenance.registerMaintenance( context,newMaintenance);

        if (kDebugMode) {
          print('Mantenimiento creado exitosamente.');
        }
      } else {
        if (kDebugMode) {
          print('Error: Faltan datos para la creación del mantenimiento.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: No se pudo crear el mantenimiento. Detalles: $e');
      }
    }
  }
}
