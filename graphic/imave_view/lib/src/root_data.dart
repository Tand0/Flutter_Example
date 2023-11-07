import 'package:flutter/material.dart';
import 'my_select.dart';

class RouteData {
  String callName;
  String title;
  WidgetBuilder builder;
  RouteData(this.callName, this.title, this.builder);
}

class RootData with ChangeNotifier {
  Map<String, WidgetBuilder> _route = {};

  RootData() {
    route[MySelect.callName] = (BuildContext context) => const MySelect();
  }

  set route(s) {
    _route = s;
  }

  get route => _route;

  void pushNamed(BuildContext context, String callName, WidgetBuilder builder,
      var someDynamicValue) {
    route[callName] = builder;
    if (someDynamicValue != null) {
      Navigator.of(context).pushNamed(callName, arguments: someDynamicValue);
    } else {
      Navigator.of(context).pushNamed(callName);
    }
  }
}
