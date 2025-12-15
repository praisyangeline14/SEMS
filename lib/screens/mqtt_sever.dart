import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class RelayControlPage extends StatefulWidget {
  const RelayControlPage({super.key});

  @override
  State<RelayControlPage> createState() => _RelayControlPageState();
}

class _RelayControlPageState extends State<RelayControlPage> {
  late MqttServerClient client;
  bool isConnected = false;

  final String broker = 'broker.hivemq.com';
  final String topic = 'stemland/esp32/relay1';

  @override
  void initState() {
    super.initState();
    connectMQTT();
  }

  Future<void> connectMQTT() async {
    client = MqttServerClient(broker, 'flutter_${DateTime.now().millisecondsSinceEpoch}');
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.logging(on: false);

    client.onConnected = () {
      setState(() => isConnected = true);
      debugPrint("MQTT Connected");
    };

    client.onDisconnected = () {
      setState(() => isConnected = false);
      debugPrint("MQTT Disconnected");
    };

    final connMess = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      debugPrint("MQTT connection failed: $e");
      client.disconnect();
    }
  }

  void publishMessage(String message) {
    if (!isConnected) return;

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    client.publishMessage(
      topic,
      MqttQos.atMostOnce,
      builder.payload!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESP32 Relay Control"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isConnected ? "MQTT Connected" : "Connecting to MQTT...",
              style: TextStyle(
                fontSize: 16,
                color: isConnected ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () => publishMessage("ON"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                "TURN ON",
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => publishMessage("OFF"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text(
                "TURN OFF",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }
}
