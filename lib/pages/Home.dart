import 'package:flutter/material.dart';
import 'package:flutter_charts_app/widgets/selectRoom.dart';
import 'package:provider/provider.dart';

import '../providers/roomProvider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String favSchool = "";
  String favBranch = "";
  String favRoom = "";

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
          if (roomProvider.favouriteSchool != "" &&
              roomProvider.favouriteBranch != "" &&
              roomProvider.favouriteRoom != "")
          SelectRoom(
            function: setRoomData,
            selectedSchool: roomProvider.favouriteSchool,
            selectedBranch: roomProvider.favouriteBranch,
            selectedRoom: roomProvider.favouriteRoom,
          )
        ],
      ),
    );
  }

  setRoomData(String school, String branch, String room) {
    favSchool = school;
    favBranch = branch;
    favRoom = room;
  }
}
