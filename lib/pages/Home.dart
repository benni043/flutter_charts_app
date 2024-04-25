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

enum Range { day, month, year }

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    String currentFormattedDate = formatDate(DateTime.now());
    formattedDate = currentFormattedDate;
    dateInput.text = currentFormattedDate;
  }

  String formattedDate = "";
  late DateTime date = DateTime.now();

  TextEditingController dateInput = TextEditingController();

  String formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

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
          datePicker(),
          getRange(),
          FutureBuilder(
            future: getGraphForRange(date, _range),
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
          graphType(),
        ],
      ),
    );
  }

  datePicker() {
    return SizedBox(
      width: 180,
      child: TextField(
          controller: dateInput,
          decoration: const InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: "Geben Sie ein Datum an!"),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDate: DateTime.now(),
              firstDate: DateTime(1999),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                          primary: Colors.lightBlue,
                          onBackground: Color.fromRGBO(0, 0, 0, 0.2))),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              formattedDate = formatDate(pickedDate);
              date = pickedDate;

              setState(() {
                dateInput.text = formattedDate;
              });
            }
          }),
    );
  }

  YAxis _yAxis = YAxis.co2;

  Widget graphType() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 600,
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: ListTile(
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
            ),
            SizedBox(
              width: 180,
              child: ListTile(
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
            ),
            SizedBox(
              width: 160,
              child: ListTile(
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
            ),
            SizedBox(
              width: 120,
              child: ListTile(
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Range _range = Range.day;

  Widget getRange() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 450,
        child: Row(
          children: [
            SizedBox(
              width: 150,
              child: ListTile(
                title: const Text("Tag"),
                leading: Radio<Range>(
                  value: Range.day,
                  groupValue: _range,
                  onChanged: (Range? range) {
                    setState(() {
                      _range = range!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: ListTile(
                title: const Text("Monat"),
                leading: Radio<Range>(
                  value: Range.month,
                  groupValue: _range,
                  onChanged: (Range? range) {
                    setState(() {
                      _range = range!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: ListTile(
                title: const Text("Jahr"),
                leading: Radio<Range>(
                  value: Range.year,
                  groupValue: _range,
                  onChanged: (Range? range) {
                    setState(() {
                      _range = range!;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getGraphForRange(DateTime dateTime, Range range) async {
    UrlProvider urlProvider = Provider.of<UrlProvider>(context, listen: false);

    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);

    List<List<SensorData>> allLists = [];

    for (var room in roomProvider.currentRooms) {
      String year = dateTime.year.toString().padLeft(2, "0");
      String month = dateTime.month.toString().padLeft(2, "0");
      String day = dateTime.day.toString().padLeft(2, "0");

      List<SensorData> list;

      switch (range) {
        case Range.day:
          {
            list = await SensorData.getSensorDataForADay(
                "${urlProvider.url}sensorData_2/${room.school}/${room.branch}/${room.room}/$year/$month/$day.json");
          }
        case Range.month:
          list = await SensorData.getSensorDataForAMonth(
              "${urlProvider.url}sensorData_2/${room.school}/${room.branch}/${room.room}/$year/$month");
        case Range.year:
          list = await SensorData.getSensorDataForAYear(
              "${urlProvider.url}sensorData_2/${room.school}/${room.branch}/${room.room}/$year");
      }

      allLists.add(list);
    }

    return getGraph(allLists);
  }

  getGraph(List<List<SensorData>> allLists) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: 1000,
        child: SfCartesianChart(
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
                  name:
                      "${allLists[i][0].room.school}/${allLists[i][0].room.branch}/${allLists[i][0].room.room} - Temperature",
                ),
            if (_yAxis == YAxis.all || _yAxis == YAxis.humidity)
              for (int i = 0; i < allLists.length; i++)
                LineSeries<SensorData, String>(
                  dataSource: allLists[i],
                  xValueMapper: (SensorData data, _) => data.time,
                  yValueMapper: (SensorData data, _) => data.humidity,
                  yAxisName: "YAxis1",
                  name:
                      "${allLists[i][0].room.school}/${allLists[i][0].room.branch}/${allLists[i][0].room.room} - Humidity",
                ),
            if (_yAxis == YAxis.all || _yAxis == YAxis.co2)
              for (int i = 0; i < allLists.length; i++)
                LineSeries<SensorData, String>(
                  dataSource: allLists[i],
                  xValueMapper: (SensorData data, _) => data.time,
                  yValueMapper: (SensorData data, _) => data.co2,
                  yAxisName: "YAxis2",
                  name:
                      "${allLists[i][0].room.school}/${allLists[i][0].room.branch}/${allLists[i][0].room.room} - CO2",
                ),
          ],
          primaryYAxis: const NumericAxis(isVisible: false),
          axes: <ChartAxis>[
            NumericAxis(
              name: "YAxis0",
              title: const AxisTitle(text: "Temperature"),
              opposedPosition: _yAxis == YAxis.temperature ? false : true,
            ),
            NumericAxis(
              name: "YAxis1",
              title: const AxisTitle(text: "CO2"),
              opposedPosition:
                  (_yAxis == YAxis.co2 || _yAxis == YAxis.all) ? false : true,
            ),
            NumericAxis(
              name: "YAxis2",
              title: const AxisTitle(text: "Humidity"),
              opposedPosition: _yAxis == YAxis.humidity ? false : true,
            ),
          ],
          legend: const Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(
            enable: true,
          ),
        ),
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
