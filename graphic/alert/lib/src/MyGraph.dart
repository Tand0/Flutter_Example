import 'package:alert/src/MyComponent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'NodeData.dart';

class MyGraph extends StatefulWidget {
  static const String callName = "/Grap";
  const MyGraph({super.key});
  @override
  createState() => _MyGraph();
}

class _MyGraph extends State<MyGraph> {
  int selectedIndex = 0;
  String iconString = edit;
  static const select = 'Select';
  static const copy = 'Copy';
  static const move = 'Move';
  static const expand = 'Expand';
  static const edit = 'Edit';
  static const data = 'Data';
  static const remove = 'Remove';
  static const link = 'Link';
  static const Map<String, Icon> iconList = {
    edit: Icon(Icons.edit),
    data: Icon(Icons.data_array),
    select: Icon(Icons.select_all),
    copy: Icon(Icons.copy),
    move: Icon(Icons.move_down),
    expand: Icon(Icons.expand),
    remove: Icon(Icons.delete),
    link: Icon(Icons.link),
  };
  String? selectedID;
  String? copyID;

  @override
  Widget build(BuildContext context) {
    final NodeData nodeData = Provider.of<NodeData>(context, listen: true);
    _MyCustomPainter me =
        _MyCustomPainter(nodeData, iconString, selectedID, copyID);
    String topIcon = (iconString == remove) ? remove : edit;
    String secondIcon = (iconString == move)
        ? move
        : (iconString == expand)
            ? expand
            : select;
    return Scaffold(
        appBar: AppBar(
            title: const Text(MyGraph.callName),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: Row(children: [
          NavigationRail(
            destinations: [
              NavigationRailDestination(
                icon: iconList[topIcon]!,
                label: Text(topIcon),
              ),
              NavigationRailDestination(
                icon: iconList[secondIcon]!,
                label: Text(secondIcon),
              ),
              NavigationRailDestination(
                icon: iconList[copy]!,
                label: const Text(copy),
              ),
              NavigationRailDestination(
                icon: iconList[data]!,
                label: const Text(edit),
              ),
              NavigationRailDestination(
                icon: iconList[link]!,
                label: const Text(link),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (menuInex) {
              setState(() {
                selectedIndex = menuInex;
                if (menuInex == 0) {
                  if (iconString == edit) {
                    iconString = remove;
                  } else {
                    iconString = edit;
                  }
                } else if (menuInex == 1) {
                  if (menuInex == selectedIndex) {
                    if (iconString == select) {
                      iconString = move;
                    } else if (iconString == move) {
                      iconString = expand;
                    } else {
                      iconString = select;
                    }
                  }
                } else if (menuInex == 2) {
                  iconString = copy;
                } else if (menuInex == 3) {
                  String target = MyComponent.callName;
                  target += "/";
                  target += selectedID ?? NodeData.topID;
                  nodeData.pushNamed(context, target,
                      (BuildContext context) => const MyComponent());
                } else if (menuInex == 4) {
                  if (selectedID != null) {
                    if (copyID == null) {
                      setState(() {
                        copyID = selectedID;
                      });
                    }
                    Link? link = nodeData.isLink(selectedID!, copyID!);
                    if (link == null) {
                      nodeData.updateLink(selectedID!, copyID!);
                    } else {
                      nodeData.removeLink(selectedID!, copyID!);
                    }
                  }
                }
              });
            },
          ),
          Expanded(
              child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GestureDetector(
                      onTapUp: (details) {
                        if (selectedIndex <= 2) {
                          String iconStringX = iconString;
                          me.setPoint(context, details.localPosition.dx.toInt(),
                              details.localPosition.dy.toInt());
                          if (selectedID != me.selectedID) {
                            setState(() {
                              selectedID = me.selectedID;
                            });
                          }
                          if (copyID != me.copyID) {
                            setState(() {
                              copyID = me.copyID;
                            });
                          }
                          if (iconStringX != me.iconString) {
                            setState(() {
                              iconString = me.iconString;
                            });
                          }
                        }
                      },
                      child: CustomPaint(painter: me))))
        ]));
  }
}

class _MyCustomPainter extends CustomPainter {
  _MyCustomPainter(
      this.nodeData, this.iconString, this.selectedID, this.copyID);
  final NodeData nodeData;
  String iconString;
  String? selectedID;
  String? copyID;

  void setPoint(BuildContext context, int dX, int dY) {
    Component? parent;
    int boxXMin = 0;
    int boxYMin = 0;
    List<Component> componetList =
        nodeData.getComponentList(nodeData.getComponentTop());
    for (Component c in componetList) {
      boxXMin = c.getBoxXMin();
      boxYMin = c.getBoxYMin();
      if ((boxXMin + c.x <= dX) &&
          (dX <= boxXMin + c.x + Component.isSmallSize) &&
          (boxYMin + c.y <= dY) &&
          (dY <= boxYMin + c.y + Component.isSmallSize)) {
        // small
        if (c.componentID != NodeData.topID) {
          c.isSmall = !c.isSmall;
          nodeData.notifyListeners();
        }
        return;
      }
      if ((!c.isSmall) &&
          (!c.isLock) &&
          ((iconString == _MyGraph.select) ||
              (iconString == _MyGraph.move) ||
              (iconString == _MyGraph.expand)) &&
          //
          (((boxXMin + c.x + c.width - Component.isSmallSize <= dX) &&
                  (dX <= boxXMin + c.x + c.width) &&
                  (boxYMin + c.y <= dY) &&
                  (dY <= boxYMin + c.y + Component.isSmallSize)) ||
              //
              //
              ((boxXMin + c.x + c.width - Component.isSmallSize <= dX) &&
                  (dX <= boxXMin + c.x + c.width) &&
                  (boxYMin + c.y + c.height - Component.isSmallSize <= dY) &&
                  (dY <= boxYMin + c.y + c.height)) ||
              //
              //
              ((boxXMin + c.x <= dX) &&
                  (dX <= boxXMin + c.x + Component.isSmallSize) &&
                  (boxYMin + c.y + c.height - Component.isSmallSize <= dY) &&
                  (dY <= boxYMin + c.y + c.height)))) {
        selectedID = c.componentID;
        if (iconString == _MyGraph.edit) {
          iconString = _MyGraph.select;
          selectedID = c.componentID;
          nodeData.notifyListeners();
          return;
        } else if (iconString == _MyGraph.select) {
          iconString = _MyGraph.move;
          selectedID = c.componentID;
          nodeData.notifyListeners();
          return;
        } else if (iconString == _MyGraph.move) {
          iconString = _MyGraph.expand;
          selectedID = c.componentID;
          nodeData.notifyListeners();
          return;
        } else if (iconString == _MyGraph.expand) {
          iconString = _MyGraph.select;
          selectedID = c.componentID;
          nodeData.notifyListeners();
          return;
        }
      }
      if ((!c.isSmall) &&
          (boxXMin + c.x <= dX) &&
          (dX <= boxXMin + c.x + c.width) &&
          (boxYMin + c.y <= dY) &&
          (dY <= boxYMin + c.y + c.height)) {
        if (iconString != _MyGraph.copy) {
          if ((iconString == _MyGraph.select) ||
              ((iconString == _MyGraph.move) && (selectedID == null)) ||
              ((iconString == _MyGraph.expand) && (selectedID == null)) ||
              (iconString == _MyGraph.edit) ||
              ((iconString == _MyGraph.remove) && (selectedID == null))) {
            selectedID = c.componentID;
            parent = c;
          }
        } else {
          copyID = c.componentID;
          return;
          //
        }
        break;
      }
    }
    //
    if ((parent == null) && (selectedID != null)) {
      parent = nodeData.getComponent(selectedID!);
      boxXMin = parent.getBoxXMin();
      boxYMin = parent.getBoxYMin();
    }
    //
    if ((parent != null) && (!parent.isLock) && (iconString == _MyGraph.move)) {
      // move
      parent.x = dX - boxXMin;
      parent.y = dY - boxYMin;
      nodeData.notifyListeners();
      return;
    }
    if ((parent != null) &&
        (!parent.isLock) &&
        (iconString == _MyGraph.expand)) {
      // expand
      if (dX <= boxXMin + parent.x) {
        parent.x = dX - boxXMin;
      } else if (boxXMin + parent.x + Component.minSize <= dX) {
        parent.width = dX - boxXMin - parent.x;
      } else {
        parent.width = Component.minSize;
      }
      if (dY <= boxYMin + parent.y) {
        parent.y = dY - boxYMin;
      } else if (boxYMin + parent.y + Component.minSize <= dY) {
        parent.height = dY - boxYMin - parent.y;
      } else {
        parent.height = Component.minSize;
      }
      nodeData.notifyListeners();
      return;
    }
    if ((parent != null) && (iconString == _MyGraph.edit)) {
      // Create
      boxXMin = dX - boxXMin - parent.x;
      boxYMin = dY - boxYMin - parent.y;
      String name;
      int layer = parent.getComponentLayer();
      int sizeX;
      int sizeY;
      if (layer == 0) {
        name = "Location";
        sizeX = 512;
        sizeY = 256;
      } else if (layer == 1) {
        name = "Node";
        sizeX = 256;
        sizeY = 128;
      } else {
        name = "Port";
        sizeX = Component.minSize;
        sizeY = Component.minSize;
      }
      Component me = nodeData.createComponent(
          parent, name, boxXMin, boxYMin, sizeX, sizeY);
      parent.childList.add(me);
      selectedID = me.componentID;
      //
      nodeData.notifyListeners();
      return;
    }
    if ((parent != null) &&
        (!parent.isLock) &&
        (iconString == _MyGraph.remove)) {
      // remove
      nodeData.removeComponent(selectedID!);
      selectedID = null;
      copyID = null;
      //
      nodeData.notifyListeners();
      return;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    //
    final paintX = Paint();
    paintX.color = Colors.black38;
    paintX.strokeWidth = 1.0;
    paintX.style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paintX);
    //
    Component componet = nodeData.getComponentTop();
    paintComponent(canvas, componet, 0, 0, false);
    paintLink(canvas);
    //
  }

  void paintLink(Canvas canvas) {
    final paintX = Paint();
    paintX.color = Colors.blue;
    paintX.strokeWidth = 3.0;
    for (Link link in nodeData.linkList) {
      Component componetA = nodeData.getLinkData(link.componentIDA);
      Component componetZ = nodeData.getLinkData(link.componentIDZ);
      if (componetA != componetZ) {
        int boxAX;
        int boxAY;
        if (!componetA.isSmall) {
          boxAX = componetA.getBoxXMin() + componetA.x + componetA.width ~/ 2;
          boxAY = componetA.getBoxYMin() + componetA.y + componetA.height ~/ 2;
          final center = Offset(boxAX.toDouble(), boxAY.toDouble());
          double radius = Component.isSmallSize / 2;
          canvas.drawCircle(center, radius, paintX);
        } else {
          boxAX =
              componetA.getBoxXMin() + componetA.x + Component.isSmallSize ~/ 2;
          boxAY =
              componetA.getBoxYMin() + componetA.y + Component.isSmallSize ~/ 2;
        }
        //
        int boxZX;
        int boxZY;
        if (!componetZ.isSmall) {
          boxZX = componetZ.getBoxXMin() + componetZ.x + componetZ.width ~/ 2;
          boxZY = componetZ.getBoxYMin() + componetZ.y + componetZ.height ~/ 2;
          final center = Offset(boxZX.toDouble(), boxZY.toDouble());
          double radius = Component.isSmallSize / 2;
          canvas.drawCircle(center, radius, paintX);
        } else {
          boxZX =
              componetZ.getBoxXMin() + componetZ.x + Component.isSmallSize ~/ 2;
          boxZY =
              componetZ.getBoxYMin() + componetZ.y + Component.isSmallSize ~/ 2;
        }
        canvas.drawLine(Offset(boxAX.toDouble(), boxAY.toDouble()),
            Offset(boxZX.toDouble(), boxZY.toDouble()), paintX);
      } else if (!componetA.isSmall) {
        int boxAX = componetA.getBoxXMin() + componetA.x + componetA.width ~/ 2;
        int boxAY = componetA.getBoxYMin() +
            componetA.y +
            componetA.height ~/ 2 +
            Component.minSize ~/ 2;
        // loopback
        paintX.style = PaintingStyle.stroke;
        final center = Offset(boxAX.toDouble(), boxAY.toDouble());
        double radius = Component.minSize / 2;
        canvas.drawCircle(center, radius, paintX);
      }
    }
  }

  void paintComponent(Canvas canvas, Component componet, int boxXMin,
      int boxYMin, bool chaild) {
    final paintX = Paint();
    //
    if (selectedID != null &&
        (selectedID == componet.componentID) &&
        copyID != null &&
        (copyID == componet.componentID)) {
      paintX.color = Colors.purple;
      chaild = true;
    } else if (selectedID != null && (selectedID == componet.componentID)) {
      paintX.color = Colors.pink;
      chaild = true;
    } else if (copyID != null && (copyID == componet.componentID)) {
      paintX.color = Colors.orange;
      chaild = true;
    } else if (chaild) {
      paintX.color = Colors.black38;
    } else {
      paintX.color = Colors.white;
    }
    //
    int xMin = boxXMin + componet.x;
    int yMin = boxYMin + componet.y;
    if (componet.isSmall) {
      paintX.style = PaintingStyle.fill;
      if (paintX.color == Colors.white) {
        paintX.color = Colors.grey;
      }
      final center = Offset(
          xMin + Component.isSmallSize / 2, yMin + Component.isSmallSize / 2);
      double radius = Component.isSmallSize / 2;
      canvas.drawCircle(center, radius, paintX);
      return;
    }

    //
    paintX.strokeWidth = 1.0;
    paintX.style = PaintingStyle.fill;
    int xMax = xMin + componet.width;
    int yMax = yMin + componet.height;
    var path = Path();
    path.moveTo(xMin.toDouble(), yMin.toDouble());
    path.lineTo(xMin.toDouble(), yMax.toDouble());
    path.lineTo(xMax.toDouble(), yMax.toDouble());
    path.lineTo(xMax.toDouble(), yMin.toDouble());
    path.close();
    canvas.drawPath(path, paintX);
    //
    paintX.color = Colors.black;
    paintX.strokeWidth = 1.0;
    paintX.style = PaintingStyle.stroke;
    path = Path();
    path.moveTo(xMin.toDouble(), yMin.toDouble());
    path.lineTo(xMin.toDouble(), yMax.toDouble());
    path.lineTo(xMax.toDouble(), yMax.toDouble());
    path.lineTo(xMax.toDouble(), yMin.toDouble());
    path.close();
    canvas.drawPath(path, paintX);
    //
    const sampleTextStyle = TextStyle(color: Colors.black, fontSize: 12);
    TextPainter text = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        style: sampleTextStyle,
        text: componet.name,
      ),
    )..layout();
    text.paint(canvas, Offset(xMin + 4, yMin + 4));
    //
    if (selectedID != null &&
        (selectedID == componet.componentID) &&
        ((iconString == _MyGraph.select) ||
            (iconString == _MyGraph.move) ||
            (iconString == _MyGraph.expand))) {
      if (iconString == _MyGraph.select) {
        paintX.color = Colors.black;
      } else if (iconString == _MyGraph.move) {
        paintX.color = Colors.yellow;
      } else if (iconString == _MyGraph.expand) {
        paintX.color = Colors.green;
      }
      //
      paintX.strokeWidth = 2.0;
      paintX.style = PaintingStyle.stroke;
      path = Path();
      double s = Component.isSmallSize.toDouble() - 2;
      path.moveTo(xMax.toDouble() - s, yMin.toDouble());
      path.lineTo(xMax.toDouble(), yMin.toDouble());
      path.lineTo(xMax.toDouble(), yMin.toDouble() + s);
      path.lineTo(xMax.toDouble() - s, yMin.toDouble() + s);
      path.close();
      canvas.drawPath(path, paintX);
      //
      paintX.strokeWidth = 2.0;
      paintX.style = PaintingStyle.stroke;
      path = Path();
      path.moveTo(xMax.toDouble() - s, yMax.toDouble() - s);
      path.lineTo(xMax.toDouble(), yMax.toDouble() - s);
      path.lineTo(xMax.toDouble(), yMax.toDouble());
      path.lineTo(xMax.toDouble() - s, yMax.toDouble());
      path.close();
      canvas.drawPath(path, paintX);
      //
      paintX.strokeWidth = 2.0;
      paintX.style = PaintingStyle.stroke;
      path = Path();
      path.moveTo(xMin.toDouble(), yMax.toDouble() - s);
      path.lineTo(xMin.toDouble() + s, yMax.toDouble() - s);
      path.lineTo(xMin.toDouble() + s, yMax.toDouble());
      path.lineTo(xMin.toDouble(), yMax.toDouble());
      path.close();
      canvas.drawPath(path, paintX);
      //
    }
    //
    boxXMin += componet.x;
    boxYMin += componet.y;
    for (var element in componet.childList) {
      paintComponent(canvas, element, boxXMin, boxYMin, chaild);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
