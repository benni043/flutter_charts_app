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

  static Future<List<SensorData>> getSensorDataForADay(String path) async {
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

  static getSensorDataForAMonth(String path) async {
    var response = await get(Uri.parse("$path.json?shallow=true"));
    Map<String, dynamic> map = jsonDecode(response.body);

    List<SensorData> list = [];

    for (var elem in map.keys) {
      List<SensorData> data = await getSensorDataForADay("$path/$elem.json");

      int co2Sum = 0;
      double humiditySum = 0;
      double tempSum = 0;

      for (var singleData in data) {
        co2Sum += singleData.co2;
        humiditySum += singleData.humidity;
        tempSum += singleData.temperature;
      }

      SensorData sensorData = SensorData(co2Sum ~/ data.length,
          humiditySum / data.length, tempSum / data.length, elem);

      list.add(sensorData);
    }

    return list;
  }

  static getSensorDataForAYear(String path) async {
    var response = await get(Uri.parse("$path.json?shallow=true"));
    Map<String, dynamic> map = jsonDecode(response.body);

    List<SensorData> list = [];

    for (var elem in map.keys) {
      List<SensorData> data = await getSensorDataForAMonth("$path/$elem");

      int co2Sum = 0;
      double humiditySum = 0;
      double tempSum = 0;

      for (var singleData in data) {
        co2Sum += singleData.co2;
        humiditySum += singleData.humidity;
        tempSum += singleData.temperature;
      }

      SensorData sensorData = SensorData(co2Sum ~/ data.length,
          humiditySum / data.length, tempSum / data.length, elem);

      list.add(sensorData);
    }

    return list;
  }
}
