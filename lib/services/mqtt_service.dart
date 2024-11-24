import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class MqttService {
  late final MqttBrowserClient client;
  bool isConnected = false;

  MqttService() {
    client = MqttBrowserClient(
      'ws://192.168.0.13:9001/mqtt',
      'paginaDeCalibracion-${DateTime.now().millisecondsSinceEpoch}',
    );

    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.setProtocolV311();
    client.autoReconnect = true;

    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
    client.onSubscribeFail = _onSubscribeFail;
    client.pongCallback = _pong;
  }

  Future<void> connect() async {
    try {
      debugPrint('Intentando conectar al broker MQTT...');
      await client.connect();

      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        isConnected = true;
        debugPrint('Conectado al broker MQTT');
      } else {
        isConnected = false;
        debugPrint(
          'Error de conexión: ${client.connectionStatus?.state}, '
          'Código de retorno: ${client.connectionStatus?.returnCode}',
        );
        client.disconnect();
      }
    } catch (e) {
      isConnected = false;
      debugPrint('Error al conectar al broker MQTT: $e');
      if (client.connectionStatus != null) {
        debugPrint(
          'Estado de conexión: ${client.connectionStatus?.state}, '
          'Código de retorno: ${client.connectionStatus?.returnCode}',
        );
      }
      client.disconnect();
    }
  }


  void publish(String topic, String message) {
    if (isConnected) {
      final payload = MqttClientPayloadBuilder();
      payload.addString(message);
      client.publishMessage(topic, MqttQos.atLeastOnce, payload.payload!);
      debugPrint('Mensaje publicado: $topic -> $message');
    } else {
      debugPrint('Error: Cliente desconectado, no se puede publicar.');
    }
  }

  void subscribe(String topic) {
    if (isConnected) {
      client.subscribe(topic, MqttQos.atLeastOnce);
      debugPrint('Suscrito al tópico: $topic');
    } else {
      debugPrint('Error: Cliente desconectado, no se puede suscribir.');
    }
  }

  void disconnect() {
    client.disconnect();
    isConnected = false;
    debugPrint('Desconectado del broker MQTT');
  }

  void listenToMessages(Function(String topic, String payload) onMessage) {
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (var message in messages) {
        final payload =
            (message.payload as MqttPublishMessage).payload.message;
        final payloadString = MqttPublishPayload.bytesToStringAsString(payload);
        onMessage(message.topic, payloadString);
      }
    });
  }

  void _onConnected() => debugPrint('Conexión exitosa con el broker MQTT');
  void _onDisconnected() => debugPrint('Conexión perdida con el broker MQTT');
  void _onSubscribed(String topic) => debugPrint('Suscripción exitosa al tópico: $topic');
  void _onSubscribeFail(String topic) => debugPrint('Error al suscribirse al tópico: $topic');
  void _pong() => debugPrint('Pong recibido del broker MQTT');
}
