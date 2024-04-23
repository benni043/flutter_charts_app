import 'package:flutter/material.dart';
import 'package:flutter_charts_app/providers/urlProvider.dart';
import 'package:flutter_charts_app/utility/sensorData.dart';
import 'package:flutter_charts_app/widgets/roomDisplay.dart';
import 'package:flutter_charts_app/widgets/selectRoom.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../providers/roomProvider.dart';
import '../utility/room.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);

    // SensorData.getSensorDataForADay("https://fluttertestprojectrefr-default-rtdb.europe-west1.firebasedatabase.app/sensorData_2/htl/if/319/2024/04/11");

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
          FutureBuilder(
            future: getGraphForADay(DateTime(2024, 4, 11)),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
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

  day(DateTime dateTime) async {
    UrlProvider urlProvider = Provider.of<UrlProvider>(context, listen: false);

    RoomProvider roomProvider =
    Provider.of<RoomProvider>(context, listen: false);

    List<List<SensorData>> allLists = [];

    for (var room in roomProvider.currentRooms) {
      String year = dateTime.year.toString().padLeft(2, '0');
      String month = dateTime.month.toString().padLeft(2, '0');
      String day = dateTime.day.toString().padLeft(2, '0');

      List<SensorData> list = await SensorData.getSensorDataForADay(
          "${urlProvider.url}sensorData_2/${room.school}/${room.branch}/${room.room}/$year/$month/$day.json");

      allLists.add(list);
    }
  }

  getGraphForADay() async {
    UrlProvider urlProvider = Provider.of<UrlProvider>(context, listen: false);

    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);

    List<List<SensorData>> allLists = [];

    for (var room in roomProvider.currentRooms) {
      String year = dateTime.year.toString().padLeft(2, '0');
      String month = dateTime.month.toString().padLeft(2, '0');
      String day = dateTime.day.toString().padLeft(2, '0');

      List<SensorData> list = await SensorData.getSensorDataForAYear(
          "${urlProvider.url}sensorData_2/${room.school}/${room.branch}/${room.room}/$year");

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
        for (int i = 0; i < allLists.length; i++)
          LineSeries<SensorData, String>(
            dataSource: allLists[i],
            xValueMapper: (SensorData data, _) => data.time,
            yValueMapper: (SensorData data, _) => data.temperature,
            yAxisName: 'YAxis0',
            name: 'Series $i',
          ),
        for (int i = 0; i < allLists.length; i++)
          LineSeries<SensorData, String>(
            dataSource: allLists[i],
            xValueMapper: (SensorData data, _) => data.time,
            yValueMapper: (SensorData data, _) => data.humidity,
            yAxisName: 'YAxis1',
            name: 'Series $i',
          ),
        for (int i = 0; i < allLists.length; i++)
          LineSeries<SensorData, String>(
            dataSource: allLists[i],
            xValueMapper: (SensorData data, _) => data.time,
            yValueMapper: (SensorData data, _) => data.co2,
            yAxisName: 'YAxis2',
            name: 'Series $i',
          ),
      ],
      primaryYAxis: const NumericAxis(isVisible: false),
      axes: const <ChartAxis>[
        NumericAxis(
          name: 'YAxis0',
          title: AxisTitle(text: 'Temperature'),
          opposedPosition: true,
        ),
        NumericAxis(
          name: 'YAxis1',
          title: AxisTitle(text: 'CO2'),
        ),
        NumericAxis(
          name: 'YAxis2',
          title: AxisTitle(text: 'Humidity'),
          opposedPosition: true,
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          String yAxisName = '';
          if (seriesIndex == 0) {
            yAxisName = 'Temperature';
          } else if (seriesIndex == 1) {
            yAxisName = 'CO2';
          } else if (seriesIndex == 2) {
            yAxisName = 'Humidity';
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
