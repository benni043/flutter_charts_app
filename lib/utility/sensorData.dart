import 'dart:convert';

import 'package:http/http.dart';

class SensorData {
  String time = "";
  int co2;
  double humidity;
  double temperature;

  SensorData(this.co2, this.humidity, this.temperature, this.time);

  @override
  String toString() {
    return 'SensorData{time: $time, co2: $co2, humidity: $humidity, temperature: $temperature}';
  }

  static Future<List<SensorData>> readSensorData(String path) async {
    var response = await get(Uri.parse(path));

    List<SensorData> sensorDataList = [];

    Map<String, dynamic> map = jsonDecode(response.body);

    for (var elem in map.entries) {
      Map<String, dynamic> map2 = elem.value as Map<String, dynamic>;

      SensorData sensorData = SensorData(
          map2["co2"], map2["humidity"], map2["temperature"], elem.key);

      sensorDataList.add(sensorData);
    }

    return sensorDataList;
  }
}