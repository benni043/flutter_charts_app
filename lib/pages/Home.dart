import 'package:flutter/material.dart';
import 'package:flutter_charts_app/widgets/roomDisplay.dart';
import 'package:flutter_charts_app/widgets/selectRoom.dart';
import 'package:provider/provider.dart';

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
            RoomDisplay(room: room, remove: remove)
        ],
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
