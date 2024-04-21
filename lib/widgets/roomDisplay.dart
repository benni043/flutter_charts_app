import 'package:flutter/material.dart';

import '../utility/Room.dart';

class RoomDisplay extends StatelessWidget {
  final Room room;
  final Function? remove;

  const RoomDisplay({super.key, required this.room, this.remove});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text("Schule: ${room.school}"),
            Text("Abteilung: ${room.branch}"),
            Text("Raum: ${room.room}"),
          ],
        ),
        if (remove != null)
          IconButton(
              onPressed: () => remove!(room), icon: const Icon(Icons.remove))
      ],
    );
  }
}
