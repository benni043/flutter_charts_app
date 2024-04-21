class Room {
  String _school;
  String _branch;
  String _room;

  Room(this._school, this._branch, this._room);

  String get room => _room;

  set room(String value) {
    _room = value;
  }

  String get branch => _branch;

  set branch(String value) {
    _branch = value;
  }

  String get school => _school;

  set school(String value) {
    _school = value;
  }
}