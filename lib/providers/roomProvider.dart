import 'package:flutter/cupertino.dart';

class RoomProvider extends ChangeNotifier {

  String _favouriteRoom = "";

  RoomProvider();

  String get favouriteRoom => _favouriteRoom;

  set favouriteRoom(String value) {
    _favouriteRoom = value;
  }
}
