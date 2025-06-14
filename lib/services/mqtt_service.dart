import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;

  Future<void> connect() async {
    // client = MqttServerClient('172.20.10.5', 'flutter_client'); // 임시 공개 브로커
    // client.port = 1883;
    // client.logging(on: true);
    // client.keepAlivePeriod = 120;
    // client.onDisconnected = onDisconnected;
    final clientId = 'flutter_client_${DateTime.now().millisecondsSinceEpoch}';
    client = MqttServerClient('172.20.10.5', clientId);
    client.port = 1883;
    client.logging(on: true);
    client.keepAlivePeriod = 120;
    client.onDisconnected = onDisconnected;


    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      print('✅ MQTT 연결 성공');
    } catch (e) {
      print('❌ MQTT 연결 실패: $e');
      // await Future.delayed(Duration(seconds: 2));
      disconnect();
    }
  }

  // void publishMessage(String topic, String message) async {
  //   if (client.connectionStatus?.state == MqttConnectionState.connected) {
  //     final builder = MqttClientPayloadBuilder();
  //     builder.addString(message);
  //     client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  //     print('📤 메시지 전송: [$topic] $message');
  //
  //     await Future.delayed(Duration(milliseconds: 800));
  //     disconnect();
  //   } else {
  //     print('⚠️ MQTT 연결이 되어 있지 않아 메시지를 전송하지 못했습니다.');
  //   }
  // }

  Future<void> publishMessage(String topic, String message) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print('📤 메시지 전송: [$topic] $message');

    // 네트워크 상황에 따라 메시지가 브로커에 안전하게 전송되도록 약간의 대기 추가
    await Future.delayed(Duration(milliseconds: 2000));

    disconnect();
  }


  void subscribeToArrivedTopic(Function(String message) onMessage) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe('robot/arrived', MqttQos.atMostOnce);

      client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c?[0].payload as MqttPublishMessage;
        final payload =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        onMessage(payload);
      });
    } else {
      print('⚠️ MQTT 연결이 되어 있지 않아 구독을 시작할 수 없습니다.');
    }
  }


  void disconnect() async {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      await Future.delayed(Duration(milliseconds: 500)); // publish 이후 안전 대기
      client.disconnect();
      print('🔌 MQTT 연결 종료됨');
    }
  }

  void onDisconnected() {
    print('⚠️ 연결 끊김!');
  }
}


