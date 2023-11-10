import 'package:flutter/material.dart';
import 'my_login.dart';
import 'package:openapi/api.dart';

typedef MyTodoCallback = void Function();
typedef MenuAction = void Function(DateTime selectDateTime, List? event,
    MenuItem item, MyTodoCallback callBack);

class MenuItem {
  String title;
  double xMax;
  double xMin;
  double yMin;
  double yMax;
  DateTime selectDateTime;
  List? event;
  MenuAction menuAction;
  MyTodoCallback callBack;
  MenuItem(this.title, this.xMin, this.xMax, this.yMin, this.yMax,
      this.selectDateTime, this.event, this.menuAction, this.callBack);
}

class RootData with ChangeNotifier {
  Map<String, WidgetBuilder> _route = {};

  RootData() {
    route[MyLogin.callName] = (BuildContext context) => MyLogin();
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

  String userName = "bob";
  String userCommuinity = "";
  bool isOffline = false;
  DateTime focused = DateTime.now();
  DateTime? selected = DateTime.now();
  final Map<DateTime, List> sampleEvents = {};
  List<MenuItem> menuItemList = [];

  void startLogin(MyTodoCallback okCallback, MyTodoCallback ngCallback) {
    Future(() async {
      final ApiClient defaultApiClient =
          ApiClient(basePath: "http://192.168.1.1:3003");
      final ApiApi apiApi = ApiApi(defaultApiClient);
      //
      //
      try {
        Token? result = await apiApi.loginForAccessTokenApiTokenPost(
            userName, userCommuinity);
        //
        if (result != null) {
          okCallback();
          print(result.toString());
        } else {
          ngCallback();
          print(result.toString());
        }
      } catch (e) {
        print(e.toString());
        ngCallback();
      }
    });
  }
}
