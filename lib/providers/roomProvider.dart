import 'package:flutter/cupertino.dart';

import '../utility/Room.dart';

class RoomProvider extends ChangeNotifier {

  Room? favouriteRooms;
  List<Room> currentRooms = [];

  RoomProvider();
}
