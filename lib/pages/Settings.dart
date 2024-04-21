import 'package:flutter/material.dart';
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
              clear: false,
              room: roomProvider.room,
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
              child:
                  const Text("Ändern", style: TextStyle(color: Colors.black)),
            ),
          ],
        ));
  }

  setFavRoom(Room room) {
    RoomProvider roomProvider =
    Provider.of<RoomProvider>(context, listen: false);

    roomProvider.room = room;
  }
}
