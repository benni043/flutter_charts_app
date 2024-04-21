import 'package:flutter/cupertino.dart';

class RoomProvider extends ChangeNotifier {

  String _favouriteSchool = "";
  String _favouriteBranch = "";
  String _favouriteRoom = "";

  RoomProvider();

  String get favouriteRoom => _favouriteRoom;

  set favouriteRoom(String value) {
    _favouriteRoom = value;
  }

  String get favouriteBranch => _favouriteBranch;

  set favouriteBranch(String value) {
    _favouriteBranch = value;
  }

  String get favouriteSchool => _favouriteSchool;

  set favouriteSchool(String value) {
    _favouriteSchool = value;
  }
}
