import 'dart:convert';

import 'package:flutter/material.dart';
import 'my_login.dart';
import 'package:openapi/api.dart' as openapi;
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
  final Map<DateTime, List> myEvents = {};
  final Map<DateTime, List> otherEvents = {};
  List<MenuItem> menuItemList = [];
  String targetURL = "";

  openapi.DefaultApi? api;
  String accessToken = "";

  void startLogin(MyTodoCallback okCallback, MyTodoCallback ngCallback) {
    Future(() async {
      try {
        String loadIP = await rootBundle.loadString('./ip.json');
        targetURL = json.decode(loadIP)["url"];

        openapi.ApiClient defaultApiClient =
            openapi.ApiClient(basePath: targetURL);
        openapi.DefaultApi defaultApi = openapi.DefaultApi(defaultApiClient);

        openapi.Token? result = await defaultApi.loginForAccessTokenTokenPost(
            userName, userCommuinity);
        //
        if (result == null) {
          throw openapi.ApiException(422, "Login failed");
        }
        accessToken = result.accessToken;

        openapi.HttpBearerAuth auth = openapi.HttpBearerAuth();
        auth.accessToken = accessToken;
        openapi.ApiClient apiClient =
            openapi.ApiClient(basePath: targetURL, authentication: auth);
        api = openapi.DefaultApi(apiClient);

        okCallback();
      } catch (e) {
        ngCallback();
      }
    });
  }

  Future<void> createUser(String targetUserName, String targetPassword) async {
    if ((api == null) || (targetUserName == '') || (targetPassword == '')) {
      throw openapi.ApiException(422, "Unprocessable Entity");
    }
    await api!.postWebUserUserPost(targetUserName, targetPassword);
    notifyListeners();
  }

  Future<List?> getUser() async {
    if (api == null) {
      throw openapi.ApiException(422, "Unprocessable Entity");
    }
    List? userNameList = await api!.getWebUserUserGet();
    if (userNameList != null) {
      otherUserNameList = [];
      for (var userName in userNameList) {
        otherUserNameList.add(userName.toString());
      }
    }
    return otherUserNameList;
  }

  Future<void> deletetUser(String targetUserName) async {
    if (api == null) {
      throw openapi.ApiException(422, "Unprocessable Entity");
    }
    await api!.deleteWebUserUserDelete(targetUserName);
    //
    notifyListeners();
    //
  }

  void postEvent(DateTime selectDateTime) {
    Future(() async {
      if (api == null) {
        throw openapi.ApiException(422, "Unprocessable Entity");
      }
      //
      int yyyy = selectDateTime.year;
      int mm = selectDateTime.month;
      int dd = selectDateTime.day;
      //
      List body = [];
      myEvents.forEach((key, value) {
        if ((key.year == yyyy) && (key.month == mm) && (key.day == dd)) {
          body.addAll(value);
        }
      });
      String jsonBody = json.encode(body);
      openapi.DayEventBody dayEventBody = openapi.DayEventBody(event: jsonBody);
      //
      await api!.postItemsUserItemsYyyyMmDdPost(yyyy, mm, dd, dayEventBody);
    });
  }

  Future<void> getEvent(DateTime? selectDateTime) async {
    if ((api == null) || (selectDateTime == null)) {
      throw openapi.ApiException(422, "Unprocessable Entity");
    }
    //
    final int yyyy = selectDateTime.year;
    final int mm = selectDateTime.month;
    //
    String? body = await api!.getItemsUserItemsYyyyMmGet(yyyy, mm);
    if (body == null) {
      throw openapi.ApiException(422, "Body is null");
    }
    var realBody = json.decode(body);
    realBody = json.decode(realBody);
    // remove dvent
    myEvents.forEach((targetDate, value) {
      if ((targetDate.year == yyyy) && (targetDate.year == mm)) {
        myEvents.remove(targetDate);
      }
    });
    otherEvents.forEach((targetDate, value) {
      if ((targetDate.year == yyyy) && (targetDate.year == mm)) {
        myEvents.remove(targetDate);
      }
    });
    //
    // add event
    realBody.forEach((dayString, value) {
      int day = int.parse(dayString);
      DateTime targetDay = DateTime.utc(yyyy, mm, day);
      value.forEach((targetName, v2) {
        List v3 = json.decode(v2);
        if (targetName.toString() == userName) {
          myEvents[targetDay] = v3;
        } else {
          otherEvents[targetDay] = v3;
        }
      });
    });
  }
}
