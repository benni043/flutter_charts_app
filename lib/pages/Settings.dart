import 'package:flutter/material.dart';
import 'package:flutter_charts_app/widgets/roomDisplay.dart';
import 'package:provider/provider.dart';

import '../providers/roomProvider.dart';
import '../providers/urlProvider.dart';
import '../utility/Room.dart';
import '../widgets/selectRoom.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _urlController = TextEditingController();

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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 600,
                    child: TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Datenbank URL")),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    urlProvider.url = _urlController.text;

                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: const Text("Ändern",
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            Row(
              children: [
                SelectRoom(
                  function: setFavRoom,
                ),
                Text("momentan: "),
                if (roomProvider.favouriteRooms != null)
                  RoomDisplay(room: roomProvider.favouriteRooms!)
                else
                  Text("keiner")
              ],
            )
          ],
        ));
  }

  setFavRoom(Room room) {
    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);

    roomProvider.favouriteRooms = room;
    if (roomProvider.currentRooms.isEmpty) roomProvider.currentRooms.add(room);

    setState(() {});
  }
}
