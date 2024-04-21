import 'package:flutter/cupertino.dart';

class UrlProvider extends ChangeNotifier {
  String _url =
      "https://fluttertestprojectrefr-default-rtdb.europe-west1.firebasedatabase.app/";

  UrlProvider();

  String get url => _url;

  set url(String value) {
    _url = value;
  }
}
