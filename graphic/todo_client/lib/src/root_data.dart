import 'dart:convert';

import 'package:flutter/material.dart';
import 'my_login.dart';
import 'package:openapi/api.dart';
import 'package:flutter/services.dart';

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
  List<String> otherUserNameList = [];
  bool isOffline = false;
  DateTime focused = DateTime.now();
  DateTime? selected = DateTime.now();
  final Map<DateTime, List> sampleEvents = {};
  List<MenuItem> menuItemList = [];
  String targetURL = "";

  ApiApi? apiApi;
  String accessToken = "";

  void startLogin(MyTodoCallback okCallback, MyTodoCallback ngCallback) {
    Future(() async {
      String loadIP = await rootBundle.loadString('./ip.json');
      targetURL = json.decode(loadIP)["url"];

      ApiClient defaultApiClient = ApiClient(basePath: targetURL);
      apiApi = ApiApi(defaultApiClient);
      //
      //
      try {
        Token? result = await apiApi!
            .loginForAccessTokenApiTokenPost(userName, userCommuinity);
        //
        if (result != null) {
          accessToken = result.accessToken;
          okCallback();
        } else {
          accessToken = '';

          ngCallback();
        }
      } catch (e) {
        ngCallback();
      }
    });
  }

  void createUser(String targetUserName, String targetPassword,
      MyTodoCallback okCallback, MyTodoCallback ngCallback) {
    Future(() async {
      try {
        if ((targetUserName == '') ||
            (targetUserName == 'root') ||
            (targetPassword == '')) {
          print("aaa");
          throw ApiException(422, "Unprocessable Entity");
        }
        print("bbb");
        HttpBearerAuth auth = HttpBearerAuth();
        auth.accessToken(accessToken);
        ApiClient defaultApiClient =
            ApiClient(basePath: targetURL, authentication: auth);
        ApiApi apiApi = ApiApi(defaultApiClient);
        await apiApi.postWebUserApiUserUsernamePost(
            targetUserName, targetPassword);
        okCallback();
      } catch (e) {
        print(e.toString());
        ngCallback();
      }
    });
  }
}
