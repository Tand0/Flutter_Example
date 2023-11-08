import 'package:flutter/material.dart';
import 'dart:math';
import 'my_select.dart';

class NodeData with ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  Map<String, WidgetBuilder> _route = {};

  NodeData() {
    route[MySelect.callName] = (BuildContext context) => const MySelect();
  }

  set route(s) {
    _route = s;
  }

  get route => _route;

  void pushNamed(BuildContext context, String callName, WidgetBuilder builder) {
    route[callName] = builder;
    Navigator.of(context).pushNamed(callName);
  }

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

  void save(Map<String, dynamic> allList) {
    var xList = allList["alarmList"];
    clearAlarm();
    for (var x in xList) {
      Alarm alarm = Alarm.fromJson(x);
      addData(alarm);
    }
    //
    _componentMap.clear();
    var jsonResult = allList["componentMap"];
    Component top = Component.fromJSON(jsonResult);
    updateParent(null, top);
    //
    _linkList.clear();
    var linkList = allList["linkList"];
    for (var x in linkList) {
      Link link = Link.fromJson(x);
      _linkList.add(link);
    }
    //
  }

  void updateParent(Component? parent, Component top) {
    top.parent = parent;
    _componentMap[top.componentID] = top;
    for (var element in top.childList) {
      updateParent(top, element);
    }
  }

  Map<String, dynamic> load() {
    return {
      "alarmList": _alarmList,
      "componentMap": getComponentTop(),
      "linkList": _linkList,
    };
  }

  final List<Alarm> _alarmList = [];

  void addData(element) {
    _alarmList.insert(0, element);
    if (100 < _alarmList.length) {
      _alarmList.removeLast();
    }
    super.notifyListeners();
  }

  Alarm getAlarm(int index) {
    if ((index < 0) || (getAlarmSize() <= index)) {
      return getDummy();
    }
    return _alarmList[index];
  }

  int getAlarmSize() {
    return _alarmList.length;
  }

  void clearAlarm() {
    _alarmList.clear();
  }

  void removeAlarm(element) {
    _alarmList.remove(element);
    super.notifyListeners();
  }

  void updateAlarm() {
    Alarm element = getDummy();
    addData(element);
  }

  final Random random = Random.secure();

  String generateRandomString([int length = 15]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final String randomStr =
        List.generate(length, (_) => charset[random.nextInt(charset.length)])
            .join();
    return randomStr;
  }

  Alarm getDummy() {
    DateTime now = DateTime.now();
    String componentID = "TODO";
    String ip =
        "${random.nextInt(253) + 1}.${random.nextInt(253) + 1}.${random.nextInt(253) + 1}.${random.nextInt(253) + 1}";
    String component = generateRandomString();
    String value = generateRandomString();
    int severity = random.nextInt(Alarm.severityList.length - 1);
    return Alarm(now, componentID, ip, component, value, severity);
  }

  final Map<String, Component> _componentMap = {};
  static const String topID = "TOP";

  Component getComponent(String componentId) {
    Component result;
    if (_componentMap.containsKey(componentId)) {
      result = _componentMap[componentId]!;
    } else {
      result = createComponent(null, componentId, 2, 2, 512 + 128, 512 + 256);
    }
    return result;
  }

  Component getComponentTop() {
    return getComponent(topID);
  }

  List<Component> getComponentList(Component top) {
    List<Component> result = [];
    if (!top.isSmall) {
      for (Component child in top.childList.reversed) {
        result.addAll(getComponentList(child));
      }
    }
    result.add(top);
    return result;
  }

  Component createComponent(
      Component? parent, String name, int x, int y, int width, int height) {
    String componentID;
    if (_componentMap.isEmpty) {
      componentID = topID;
    } else {
      while (true) {
        componentID = generateRandomString();
        if (!_componentMap.containsKey(componentID)) {
          break;
        }
      }
    }
    Component component =
        Component(parent, componentID, name, x, y, width, height);
    _componentMap[componentID] = component;
    //
    return component;
  }

  Map<String, Component> getComponentMap() {
    if (_componentMap.isEmpty) {
      getComponentTop();
    }
    return _componentMap;
  }

  void removeComponent(String componentID) {
    if (componentID == NodeData.topID) {
      return;
    }
    if (_componentMap.containsKey(componentID)) {
      Component? component = _componentMap[componentID];
      if (component?.parent != null) {
        component!.parent?.childList.remove(component);
      }
      component?.parent = null;
      component?.childList.clear();
      _componentMap.remove(componentID);
    }
    //
    for (Link link in linkList) {
      if ((link.componentIDA == componentID) ||
          (link.componentIDZ == componentID)) {
        linkList.remove(link);
      }
    }

    //
    super.notifyListeners();
  }

  Component getLinkData(String componentId) {
    Component component = getComponent(componentId);
    Component? target = component.parent;
    Component? hit;
    while (target != null) {
      if (target.isSmall) {
        hit = target;
      }
      target = target.parent;
    }
    if (hit != null) {
      return hit;
    }
    return component;
  }

  final List<Link> _linkList = [];

  get linkList => _linkList;

  Link? isLink(String componentIDA, String componentIDZ) {
    for (Link link in linkList) {
      if (((link.componentIDA == componentIDA) &&
              (link.componentIDZ == componentIDZ)) ||
          ((link.componentIDA == componentIDZ) &&
              (link.componentIDZ == componentIDA))) {
        return link;
      }
    }
    return null;
  }

  void updateLink(String componentIDA, String componentIDZ) {
    Link? link = isLink(componentIDA, componentIDZ);
    if (link == null) {
      Component componentA = getComponent(componentIDA);
      if (componentA.childList.isNotEmpty) {
        return;
      }
      Component componentZ = getComponent(componentIDA);
      if (componentZ.childList.isNotEmpty) {
        return;
      }
      link = Link(componentIDA, componentIDZ);
      linkList.add(link);
      //
      notifyListeners();
    }
  }

  void removeLink(String componentIDA, String componentIDZ) {
    for (Link link in linkList) {
      if (((link.componentIDA == componentIDA) &&
              (link.componentIDZ == componentIDZ)) ||
          ((link.componentIDA == componentIDZ) &&
              (link.componentIDZ == componentIDA))) {
        linkList.remove(link);
        break;
      }
    }
  }
}

class Component {
  static const int isSmallSize = 16;
  static const int minSize = 64;
  Component(this.parent, this.componentID, this.name, this.x, this.y,
      this.width, this.height) {
    if (width < minSize) {
      width = minSize;
    }
    if (height < minSize) {
      height = minSize;
    }
  }
  String name;
  String componentID;
  int x;
  int y;
  int width;
  int height;
  bool isLock = false;
  bool isSmall = false;
  String detail = "";
  Component? parent;
  List<Component> childList = [];

  factory Component.fromJSON(Map<String, dynamic> jsonResult) {
    var result = Component(
        null, // danger
        jsonResult['componentID'],
        jsonResult['name'],
        jsonResult['x'],
        jsonResult['y'],
        jsonResult['width'],
        jsonResult['height']);
    result.isLock = jsonResult['isLock'];
    result.isSmall = jsonResult['isSmall'];
    result.detail = jsonResult['detail'];
    //
    var list = jsonResult['childList'] as List;
    result.childList = list.map((i) => Component.fromJSON(i)).toList();
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'componentID': componentID,
      'name': name,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'isLock': isLock,
      'isSmall': isSmall,
      'detail': detail,
      'childList': childList.map((e) => e.toJson()).toList(),
    };
  }

  void fromJsonTable(Map<String, dynamic> xx) {
    name = xx["name"];
    isLock = xx["isLock"];
    isSmall = xx["isSmall"];
    detail = xx["detail"];
  }

  List<List<dynamic>> toJsonTable() {
    return [
      ["Name", "name", name],
      ["IsLock", "isLock", isLock],
      ["IsSmall", "isSmall", isSmall],
      ["Detail", "detail", detail],
    ];
  }

  int getBoxXMin() {
    int min = 0;
    Component? component = parent;
    while (component != null) {
      min += component.x;
      component = component.parent;
    }
    return min;
  }

  int getBoxYMin() {
    int min = 0;
    Component? component = parent;
    while (component != null) {
      min += component.y;
      component = component.parent;
    }
    return min;
  }

  int getComponentLayer() {
    int layer = 0;
    Component? root = parent;
    while (root != null) {
      layer++;
      root = root.parent;
    }
    return layer;
  }
}

class Link {
  String componentIDA;
  String componentIDZ;
  Link(this.componentIDA, this.componentIDZ);

  Link.fromJson(Map<String, dynamic> json)
      : componentIDA = json['componentIDA'],
        componentIDZ = json['componentIDZ'];

  Map<String, dynamic> toJson() {
    return {
      'componentIDA': componentIDA,
      'componentIDZ': componentIDZ,
    };
  }
}

class Alarm {
  static final List<String> severityList = ["CR", "MJ", "MN", "WR", "CL", "IF"];
  static final List<Color> colorList = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.white,
    Colors.white,
    Colors.white
  ];
  Alarm(this.dateTime, this.componentID, this.ip, this.componentName,
      this.value, this.severity);
  DateTime dateTime;
  String componentID;
  String ip;
  String componentName;
  String value;
  int severity;
  Color getAlarmColor() {
    Color color;
    int x = severity;
    if ((x < 0) || (colorList.length <= x)) {
      color = colorList[colorList.length - 1];
    } else {
      color = colorList[severity];
    }
    return color;
  }

  Alarm.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.parse(json['dateTime']),
        componentID = json['componentID'],
        ip = json['ip'],
        componentName = json['componentName'],
        value = json['value'],
        severity = json['severity'];

  Map<String, dynamic> toJson() {
    return {
      'dateTime': getDateTime(),
      'componentID': componentID,
      'ip': ip,
      'componentName': componentName,
      'value': value,
      'severity': severity,
    };
  }

  String getDateTime() {
    return dateTime.toIso8601String();
  }

  String getSeverity() {
    String text;
    int x = severity;
    if ((x < 0) || (colorList.length <= x)) {
      text = severityList[colorList.length - 1];
    } else {
      text = severityList[severity];
    }
    return text;
  }
}
