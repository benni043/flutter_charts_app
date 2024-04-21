import 'package:flutter/material.dart';
import 'package:flutter_charts_app/widgets/selectRoom.dart';
import 'package:provider/provider.dart';

import '../providers/roomProvider.dart';
import '../utility/Room.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Room> rooms = [];

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
            clear: true,
          ),

          for (var room in rooms) Text("${room.school} ${room.branch} ${room.room}")
        ],
      ),
    );
  }

  setRoomData(Room room) {
    rooms.add(room);

    setState(() {});
  }
}
