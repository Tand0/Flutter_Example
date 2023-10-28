import 'package:flutter/material.dart';

class RootData with ChangeNotifier {
  int _index = -1;

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

  final Map<String, List<String>> _lists = {};

  get lists => _lists;

  void addList(String name, List<String> list) {
    _lists[name] = list;
    notifyListeners();
  }

  void removeList(String name) {
    _lists.remove(name);
    notifyListeners();
  }
}
