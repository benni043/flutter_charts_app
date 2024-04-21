import 'package:flutter/cupertino.dart';

import '../utility/room.dart';

class RoomProvider extends ChangeNotifier {

  Room? favouriteRooms;
  List<Room> currentRooms = [];

  RoomProvider();
}
