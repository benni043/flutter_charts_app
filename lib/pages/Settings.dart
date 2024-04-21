import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/roomProvider.dart';
import '../providers/urlProvider.dart';
import '../widgets/selectRoom.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _urlController = TextEditingController();

  String favSchool = "";
  String favBranch = "";
  String favRoom = "";

  @override
  Widget build(BuildContext context) {
    UrlProvider urlProvider = Provider.of<UrlProvider>(context, listen: false);
    _urlController.text = urlProvider.url;

    RoomProvider roomProvider =
    Provider.of<RoomProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(title: const Text("Einstellungen")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Datenbank URL")),
              ),
            ),
            SelectRoom(
              function: setFavRoom,
              selectedSchool: roomProvider.favouriteSchool,
              selectedBranch: roomProvider.favouriteBranch,
              selectedRoom: roomProvider.favouriteRoom,
            ),
            TextButton(
              onPressed: () {
                urlProvider.url = _urlController.text;

                RoomProvider roomProvider =
                    Provider.of<RoomProvider>(context, listen: false);

                roomProvider.favouriteSchool = favSchool;
                roomProvider.favouriteBranch = favBranch;
                roomProvider.favouriteRoom = favRoom;

                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
              child:
                  const Text("Ändern", style: TextStyle(color: Colors.black)),
            ),
          ],
        ));
  }

  setFavRoom(String school, String branch, String room) {
    favSchool = school;
    favBranch = branch;
    favRoom = room;
  }
}
