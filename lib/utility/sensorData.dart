import 'dart:convert';

import 'package:flutter_charts_app/utility/room.dart';
import 'package:http/http.dart';

class SensorData {
  String time = "";
  int co2;
  double humidity;
  double temperature;

  Room room;

  SensorData(this.co2, this.humidity, this.temperature, this.time, this.room);

  @override
  String toString() {
    return 'SensorData{time: $time, co2: $co2, humidity: $humidity, temperature: $temperature}';
  }

  static Future<List<SensorData>> getSensorDataForADay(String path) async {
    var roomData = path.split("/sensorData_2")[1].split("/");
    var room = Room(roomData[1], roomData[2], roomData[3]);

    var response = await get(Uri.parse(path));

    List<SensorData> sensorDataList = [];

    Map<String, dynamic> map = jsonDecode(response.body);

    for (var elem in map.entries) {
      Map<String, dynamic> map2 = elem.value as Map<String, dynamic>;

      SensorData sensorData = SensorData(
          map2["co2"], map2["humidity"], map2["temperature"], elem.key, room);

      sensorDataList.add(sensorData);
    }

    return sensorDataList;
  }

  static getSensorDataForAMonth(String path) async {
    var roomData = path.split("/sensorData_2")[1].split("/");
    var room = Room(roomData[1], roomData[2], roomData[3]);

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
          humiditySum / data.length, tempSum / data.length, elem, room);

      list.add(sensorData);
    }

    return list;
  }

  static getSensorDataForAYear(String path) async {
    var roomData = path.split("/sensorData_2")[1].split("/");
    var room = Room(roomData[1], roomData[2], roomData[3]);

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
          humiditySum / data.length, tempSum / data.length, elem, room);

      list.add(sensorData);
    }

    return list;
  }
}
