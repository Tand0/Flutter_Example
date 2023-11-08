import 'package:flutter/material.dart';
import 'my_select.dart';

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
    Navigator.of(context).pushNamed(callName, arguments: someDynamicValue);
  }
}
