import 'package:flutter/material.dart';
import 'MyTable.dart';

class RootData with ChangeNotifier {
  Map<String, WidgetBuilder> _route = {};

  RootData() {
    route[MyTable.callName] = (BuildContext context) => const MyTable();
  }

  set route(s) {
    _route = s;
  }

  get route => _route;

  String getRouteName(BuildContext context) {
    String? name = ModalRoute.of(context)?.settings.name;
    if (name == null) {
      return '/';
    }
    return name;
  }

  String get1stRouteName(BuildContext context) {
    String? name = getRouteName(context);
    List<String> nameList = name.split('/');
    bool flag = true;
    for (String name in nameList) {
      if (name == '') {
        continue; // top folder
      }
      if (flag) {
        flag = false; // this is display name
        continue;
      }
      return name;
    }
    return '';
  }

  String getLastRouteName(BuildContext context) {
    String name = getRouteName(context);
    List<String> nameList = name.split('/');
    if (nameList.isEmpty) {
      return '';
    }
    return nameList.last;
  }

  String getCutCallNameRouteName(BuildContext context) {
    String? name = getRouteName(context);
    List<String> nameList = name.split('/');
    bool flag = true;
    String target = '';
    for (String name in nameList) {
      if (name == '') {
        continue; // top folder
      }
      if (flag) {
        flag = false; // this is display name
        continue;
      }
      target += '/';
      target += name;
    }
    return target;
  }

  Map getRootRouteValue(BuildContext context) {
    String? name = getRouteName(context);
    List<String> nameList = name.split('/');
    bool flag = true;
    for (String name in nameList) {
      if (name == '') {
        continue; // top folder
      }
      if (flag) {
        flag = false; // this is display name
        continue;
      }
      if (_lists.containsKey(name)) {
        return _lists[name];
      }
      return {};
    }
    return {};
  }

  Object? getTopRouteValue(BuildContext context) {
    String? name = getRouteName(context);
    List<String> nameList = name.split('/');
    Object? root = _lists;
    bool flag = true;
    for (String name in nameList) {
      if (name == '') {
        continue; // top folder
      }
      if (flag) {
        flag = false; // this is display name
        continue;
      }
      if (root is Map) {
        if (!root.containsKey(name)) {
          root[name] = {};
        }
        root = root[name];
      } else if (root is List) {
        int nameInt = int.parse(name);
        if ((0 <= nameInt) && (nameInt < root.length)) {
          root = root[nameInt];
        } else {
          root.add({});
          root = root.last();
        }
      }
    }
    return root;
  }

  void updateRouteValue() {
    notifyListeners();
  }

  void pushNamed(BuildContext context, String callName, WidgetBuilder builder) {
    route[callName] = builder;
    Navigator.of(context).pushNamed(callName);
  }

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

  final Map<String, dynamic> _lists = {};

  get lists => _lists;

  void addList(String name, dynamic list) {
    if (list == null) {
      _lists[name] = {};
    } else {
      _lists[name] = list;
    }
    notifyListeners();
  }

  void removeList(String name) {
    _lists.remove(name);
    notifyListeners();
  }

  void clearList() {
    _lists.clear();
    notifyListeners();
  }
}
