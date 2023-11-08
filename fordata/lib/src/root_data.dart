import 'package:flutter/material.dart';

class RootData with ChangeNotifier {
  int _index = 0;

  get index => _index;
  int getIndex() {
    return _index;
  }

  set index(s) {
    _index = s;
    notifyListeners();
  }

  void updateIndex() {
    index = _index + 1;
  }
}
