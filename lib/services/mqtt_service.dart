import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;

  Future<void> connect() async {
    client = MqttServerClient('192.168.127.239', 'flutter_client'); // 임시 공개 브로커
    client.port = 1883;
    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      print('✅ MQTT 연결 성공');
    } catch (e) {
      print('❌ MQTT 연결 실패: $e');
      disconnect();
    }
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print('📤 메시지 전송: [$topic] $message');
  }

  void disconnect() {
    client.disconnect();
    print('🔌 MQTT 연결 종료됨');
  }

  void onDisconnected() {
    print('⚠️ 연결 끊김!');
  }
}
