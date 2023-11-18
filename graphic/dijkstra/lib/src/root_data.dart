import 'dart:math';

import 'package:flutter/material.dart';
import 'my_select.dart';

class NextHop {
  Box box;
  Link link;
  NextHop(this.box, this.link);
}

class Path {
  int weight = 0;
  List<Box> boxList = [];
  List<Link> linkList = [];
  Path(this.weight, Box nextBox, Link? link, Path? path) {
    boxList.add(nextBox);
    if (link != null) {
      linkList.add(link);
    }
    if (path != null) {
      boxList.addAll(path.boxList);
      linkList.addAll(path.linkList);
    }
  }
}

class Box {
  static const String componentName = "box";
  final int size = 20;
  double x;
  double y;
  String nodeName;
  Box(this.x, this.y, this.nodeName);

  Map<String, dynamic> toJson() {
    return {
      'class': componentName,
      'x': x,
      'y': y,
      'nodeName': nodeName,
      'select': false,
    };
  }

  factory Box.fromJSON(Map<String, dynamic> jsonResult) {
    var r = Box(
      jsonResult['x'],
      jsonResult['y'],
      jsonResult['nodeName'],
    );
    return r;
  }
}

class Link {
  static const String componentName = "link";
  String aToZ;
  String zToA;
  int weight;
  Link(this.aToZ, this.zToA, this.weight);

  Map<String, dynamic> toJson() {
    return {
      'class': componentName,
      'aToZ': aToZ,
      'zToA': zToA,
      'weight': weight
    };
  }

  factory Link.fromJSON(Map<String, dynamic> jsonResult) {
    return Link(jsonResult['aToZ'], jsonResult['zToA'], jsonResult['weight']);
  }
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

  void pushNamed(BuildContext context, String callName, WidgetBuilder builder) {
    route[callName] = builder;
    Navigator.of(context).pushNamed(callName);
  }

  Map<String, dynamic> baseMAp = {};

  void changedData() {
    super.notifyListeners();
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

  Map<String, dynamic> getComponent() {
    if (!baseMAp.containsKey("component")) {
      baseMAp["component"] = <String, dynamic>{};
    }
    return baseMAp["component"];
  }

  void createComponet(Object object) {
    while (true) {
      String str = generateRandomString();
      if (baseMAp.containsKey(str)) {
        continue;
      }
      getComponent()[str] = object;
      break;
    }
  }

  String? findComponet(Object object) {
    String? targetKey;
    for (String key in getComponent().keys) {
      var value = getComponent()[key];
      if (value == object) {
        targetKey = key;
        break;
      }
    }
    return targetKey;
  }

  void deleteComponet(Object object) {
    String? targetKey = findComponet(object);
    if (targetKey == null) {
      return;
    }
    getComponent().remove(targetKey);
    //
    if (object is Box) {
      while (true) {
        String? hitKey;
        for (String key in getComponent().keys) {
          var value = getComponent()[key];
          if (value is Link) {
            if ((value.aToZ == targetKey) || (value.zToA == targetKey)) {
              hitKey = key;
              break;
            }
          }
        }
        if (hitKey == null) {
          break;
        }
        getComponent().remove(hitKey);
      }
    }
  }

  createLink(Box aToZ, Box zToA, int weight) {
    if (aToZ == zToA) {
      return;
    }
    String? a = findComponet(aToZ);
    String? z = findComponet(zToA);
    if ((a == null) || (z == null) || (a == z)) {
      return;
    }
    Link? hitLink;
    for (String id in getComponent().keys) {
      var value = getComponent()[id];
      if (value is Link) {
        if (((value.aToZ == a) && (value.zToA == z)) ||
            ((value.aToZ == z) && (value.zToA == a))) {
          hitLink = value;
          break;
        }
      }
    }
    if (hitLink != null) {
      if (weight == 0) {
        // this is delete
        deleteComponet(hitLink);
      } else {
        hitLink.weight = weight;
      }
    } else {
      Link link = Link(a, z, weight);
      createComponet(link);
    }
  }

  Path? criticalPath;
  void dijkstra(Box aToZ, Box zToA) {
    // init
    criticalPath = null;
    List<Path> pathList = [];
    pathList.add(Path(0, aToZ, null, null));
    int maxHop = 30;
    //
    while (pathList.isNotEmpty) {
      Path now = getMinWeightPath(pathList);
      pathList.remove(now);
      if (now.boxList.first == zToA) {
        if ((criticalPath == null) || (now.weight < criticalPath!.weight)) {
          criticalPath = now;
          continue;
        }
      }
      pathList.addAll(getChildPath(now));

      //
      //
      while (true) {
        Path? a;
        Path? b;
        for (int i = 0; i < pathList.length; i++) {
          for (int j = i + 1; j < pathList.length; j++) {
            if (i == 0) {
              continue;
            }
            if (pathList[i].boxList.first == pathList[j].boxList.first) {
              a = pathList[i];
              b = pathList[j];
              break;
            }
          }
          if ((a != null) && (b != null)) {
            break;
          }
        }
        if ((a != null) && (b != null)) {
          if (b.weight < a.weight) {
            pathList.remove(a);
          } else {
            pathList.remove(b);
          }
        } else {
          break;
        }
      }
      if (maxHop < now.boxList.length) {
        break;
      }
    }
  }

  List<Path> getChildPath(Path me) {
    List<Path> pathList = [];
    List<NextHop> nextHopList = getNextHopList(me.boxList.first);
    for (NextHop nextHop in nextHopList) {
      if (me.boxList.contains(nextHop.box)) {
        continue;
      }
      pathList.add(
          Path(me.weight + nextHop.link.weight, nextHop.box, nextHop.link, me));
    }
    return pathList;
  }

  List<NextHop> getNextHopList(Box latest) {
    List<NextHop> nextHopList = [];
    String? oldId = findComponet(latest);
    if (oldId == null) {
      return nextHopList;
    }
    for (String key in getComponent().keys) {
      var value = getComponent()[key];
      if (value is Link) {
        if ((value.aToZ == oldId) || (value.zToA == oldId)) {
          String nextId = value.aToZ != oldId ? value.aToZ : value.zToA;
          if (getComponent().containsKey(nextId)) {
            var box = getComponent()[nextId];
            nextHopList.add(NextHop(box, value));
          }
        }
      }
    }
    return nextHopList;
  }

  Path getMinWeightPath(List<Path> pathList) {
    Path target = pathList[0];
    for (Path now in pathList) {
      if (now.weight < target.weight) {
        target = now;
      }
    }
    return target;
  }

  void fromJSON(Map<String, dynamic> message) {
    getComponent().clear();
    if (message.containsKey("component") &&
        (message["component"] != null) &&
        (message["component"].isNotEmpty)) {
      for (String id in message["component"].keys) {
        Object component = message["component"][id];
        if ((component is Map<String, dynamic>) &&
            component.containsKey("class")) {
          if (component["class"] == Box.componentName) {
            getComponent()[id] = Box.fromJSON(component);
          } else if (component["class"] == Link.componentName) {
            getComponent()[id] = Link.fromJSON(component);
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result["component"] = {};
    //
    for (String id in getComponent().keys) {
      result["component"][id] = getComponent()[id].toJson();
    }
    return result;
  }
}
