import "package:flutter/material.dart";
import "package:flutter_charts_app/providers/urlProvider.dart";
import "package:flutter_charts_app/utility/sensorData.dart";
import "package:flutter_charts_app/widgets/roomDisplay.dart";
import "package:flutter_charts_app/widgets/selectRoom.dart";
import "package:provider/provider.dart";
import "package:syncfusion_flutter_charts/charts.dart";

import "../providers/roomProvider.dart";
import "../utility/room.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum YAxis { co2, temperature, humidity, all }

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Hauptansicht"), actions: [
        IconButton(
            onPressed: () async {
              await Navigator.pushNamed(context, "/settings");
              setState(() {});
            },
            icon: const Icon(Icons.settings))
      ]),
      body: Column(
        children: [
          SelectRoom(
            function: setRoomData,
          ),
          for (var room in roomProvider.currentRooms)
            RoomDisplay(room: room, remove: remove),
          radioButtons(),
          FutureBuilder(
            future: getGraphForADay(DateTime(2024, 4, 11)),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: snapshot.data as Widget,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  YAxis _yAxis = YAxis.co2;

  Widget radioButtons() {
    return Column(
      children: [
        ListTile(
          title: const Text("CO2"),
          leading: Radio<YAxis>(
            value: YAxis.co2,
            groupValue: _yAxis,
            onChanged: (YAxis? yAxis) {
              setState(() {
                _yAxis = yAxis!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text("Temperatur"),
          leading: Radio<YAxis>(
            value: YAxis.temperature,
            groupValue: _yAxis,
            onChanged: (YAxis? yAxis) {
              setState(() {
                _yAxis = yAxis!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text("Humidity"),
          leading: Radio<YAxis>(
            value: YAxis.humidity,
            groupValue: _yAxis,
            onChanged: (YAxis? yAxis) {
              setState(() {
                _yAxis = yAxis!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text("Alle"),
          leading: Radio<YAxis>(
            value: YAxis.all,
            groupValue: _yAxis,
            onChanged: (YAxis? yAxis) {
              setState(() {
                _yAxis = yAxis!;
              });
            },
          ),
        )
      ],
    );
  }

  getGraphForADay(DateTime dateTime) async {
    UrlProvider urlProvider = Provider.of<UrlProvider>(context, listen: false);

    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);

    List<List<SensorData>> allLists = [];

    for (var room in roomProvider.currentRooms) {
      String year = dateTime.year.toString().padLeft(2, "0");
      String month = dateTime.month.toString().padLeft(2, "0");
      String day = dateTime.day.toString().padLeft(2, "0");

      List<SensorData> list = await SensorData.getSensorDataForADay(
          "${urlProvider.url}sensorData_2/${room.school}/${room.branch}/${room.room}/$year/$month/$day.json");

      allLists.add(list);
    }

    return SfCartesianChart(
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        enablePinching: true,
        zoomMode: ZoomMode.xy,
      ),
      primaryXAxis: const CategoryAxis(),
      series: <CartesianSeries>[
        if (_yAxis == YAxis.all || _yAxis == YAxis.temperature)
          for (int i = 0; i < allLists.length; i++)
            LineSeries<SensorData, String>(
              dataSource: allLists[i],
              xValueMapper: (SensorData data, _) => data.time,
              yValueMapper: (SensorData data, _) => data.temperature,
              yAxisName: "YAxis0",
              name: "Series $i",
            ),
        if (_yAxis == YAxis.all || _yAxis == YAxis.humidity)
          for (int i = 0; i < allLists.length; i++)
            LineSeries<SensorData, String>(
              dataSource: allLists[i],
              xValueMapper: (SensorData data, _) => data.time,
              yValueMapper: (SensorData data, _) => data.humidity,
              yAxisName: "YAxis1",
              name: "Series $i",
            ),
        if (_yAxis == YAxis.all || _yAxis == YAxis.co2)
          for (int i = 0; i < allLists.length; i++)
            LineSeries<SensorData, String>(
              dataSource: allLists[i],
              xValueMapper: (SensorData data, _) => data.time,
              yValueMapper: (SensorData data, _) => data.co2,
              yAxisName: "YAxis2",
              name: "Series $i",
            ),
      ],
      primaryYAxis: const NumericAxis(isVisible: false),
      axes: <ChartAxis>[
        // if (_yAxis == YAxis.all || _yAxis == YAxis.temperature)
          NumericAxis(
            name: "YAxis0",
            title: const AxisTitle(text: "Temperature"),
            opposedPosition: _yAxis == YAxis.temperature ? false : true,
          ),
        // if (_yAxis == YAxis.all || _yAxis == YAxis.co2)
          const NumericAxis(
            name: "YAxis1",
            title: AxisTitle(text: "CO2"),
          ),
        // if (_yAxis == YAxis.all || _yAxis == YAxis.humidity)
          NumericAxis(
            name: "YAxis2",
            title: const AxisTitle(text: "Humidity"),
            opposedPosition: _yAxis == YAxis.humidity ? false : true,
          ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          String yAxisName = "";
          if (seriesIndex == 0) {
            yAxisName = "Temperature";
          } else if (seriesIndex == 1) {
            yAxisName = "CO2";
          } else if (seriesIndex == 2) {
            yAxisName = "Humidity";
          }
          return Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Text("$yAxisName - ${point.y}"),
          );
        },
      ),
    );
  }

  setRoomData(Room room) {
    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);

    roomProvider.currentRooms.add(room);

    setState(() {});
  }

  remove(Room room) {
    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);

    roomProvider.currentRooms.remove(room);

    setState(() {});
  }
}
