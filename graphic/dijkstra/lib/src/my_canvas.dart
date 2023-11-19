import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'root_data.dart' as data;

typedef MenuAction = void Function();

class MenuItem {
  String title;
  double xMin;
  double xMax = 0;
  double yMin;
  double yMax = 0;
  MenuAction menuAction;
  MenuItem(this.title, this.xMin, this.yMin, this.menuAction);
}

class MyCanvas extends StatefulWidget {
  const MyCanvas({Key? key}) : super(key: key);

  static const title = "Show Canvas";
  static const callName = "/Canvas";

  @override
  State<MyCanvas> createState() => _MyCanvas();
}

class _MyCanvas extends State<MyCanvas> {
  List<MenuItem> menuItemList = [];
  double xPoint = 0;
  double yPoint = 0;
  bool isMove = false;
  data.Box? selectedBox;
  data.Box? linkedBox;

  @override
  Widget build(BuildContext context) {
    final data.RootData rootData =
        Provider.of<data.RootData>(context, listen: true);
    _MyCustomPainter me = _MyCustomPainter(this, rootData);
    return Scaffold(
        appBar: AppBar(
            title: const Text(MyCanvas.title),
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios))),
        body: Column(children: [
          Expanded(
              child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GestureDetector(
                      onTapUp: (details) {
                        double dx = details.localPosition.dx;
                        double dy = details.localPosition.dy;
                        setState(() {
                          me.setPoint(context, dx, dy);
                          if (linkedBox != null) {
                            data.Box targetBox = linkedBox!;
                            linkedBox = null;
                            showDialog<void>(
                                context: context,
                                builder: (_) {
                                  return MyItemDialog(
                                      rootData: rootData,
                                      linkedBox: targetBox,
                                      selectedBox: selectedBox!);
                                });
                          }
                        });
                      },
                      child: CustomPaint(painter: me))))
        ]));
  }
}

class _MyCustomPainter extends CustomPainter {
  double xMax = 0;
  double yMax = 0;
  data.RootData rootData;
  _MyCanvas myCanvas;
  _MyCustomPainter(this.myCanvas, this.rootData);

  void move(data.Box box) {
    myCanvas.isMove = true;
    select(box);
  }

  void doMove(double dx, double dy) {
    for (String key in rootData.getComponent().keys) {
      var value = rootData.getComponent()[key];
      if ((value is data.Box) && (myCanvas.selectedBox != null)) {
        value.x = dx;
        value.y = dy;
        break;
      }
    }
  }

  void select(data.Box box) {
    myCanvas.selectedBox = box;
  }

  void link(data.Box box) {
    if ((myCanvas.selectedBox == null) || (myCanvas.selectedBox == box)) {
      return;
    }
    myCanvas.linkedBox = box;
  }

  void dijkstra(data.Box box) {
    if (myCanvas.selectedBox == null) {
      return;
    }
    rootData.dijkstra(box, myCanvas.selectedBox!);
    rootData.changedData();
  }

  void delete(data.Box box) {
    rootData.deleteComponet(box);
  }

  void past() {
    String name = "Node-${rootData.getComponent().length}";
    data.Box myBox = data.Box(myCanvas.xPoint, myCanvas.yPoint, name);
    rootData.createComponet(myBox);
    //
    select(myBox);
  }

  void setPoint(BuildContext context, double dx, double dy) {
    if (myCanvas.isMove) {
      doMove(dx, dy);
      myCanvas.isMove = false;
    } else if (myCanvas.menuItemList.isEmpty) {
      setPointNonMenu(context, dx, dy);
    } else {
      setPointMenu(context, dx, dy);
    }
  }

  void setPointNonMenu(BuildContext context, double dx, double dy) {
    Map map = rootData.getComponent();
    bool hitFlag = false;
    for (var v in map.values) {
      if (v is data.Box) {
        if ((v.x <= dx) &&
            (dx <= v.x + v.size) &&
            (v.y <= dy) &&
            (dy <= v.y + v.size)) {
          hitFlag = true;
          myCanvas.xPoint = dx;
          myCanvas.yPoint = dy;
          myCanvas.menuItemList = [
            MenuItem("Move", dx, dy, () => move(v)),
            MenuItem("Select", dx, dy, () => select(v)),
            MenuItem("Link", dx, dy, () => link(v)),
            MenuItem("Dijkstra", dx, dy, () => dijkstra(v)),
            MenuItem("Delete", dx, dy, () => delete(v)),
          ];
          break;
        }
      }
    }
    if (!hitFlag) {
      myCanvas.xPoint = dx;
      myCanvas.yPoint = dy;
      myCanvas.menuItemList = [
        MenuItem("Paste", dx, dy, () => past()),
      ];
    }
  }

  void setPointMenu(BuildContext context, double dx, double dy) {
    //
    for (MenuItem item in myCanvas.menuItemList) {
      if ((item.xMin < dx) &&
          (dx < item.xMax) &&
          (item.yMin < dy) &&
          (dy < item.yMax)) {
        item.menuAction();
      }
    }
    myCanvas.menuItemList = [];
  }

  @override
  void paint(Canvas canvas, Size size) {
    xMax = size.width;
    yMax = size.height;
    final paintX = Paint();
    paintX.strokeWidth = 1.0;
    const sampleTextStyle = TextStyle(color: Colors.black, fontSize: 12);
    paintNormal(canvas, size, paintX, sampleTextStyle);
    if (myCanvas.menuItemList.isNotEmpty) {
      paintMenu(canvas, size, paintX, sampleTextStyle);
    }
  }

  void paintNormal(
      Canvas canvas, Size size, Paint paintX, TextStyle sampleTextStyle) {
    var component = rootData.getComponent();

    for (String x in component.keys) {
      var value = component[x];
      if (value is data.Link) {
        String aToZ = value.aToZ;
        String zToA = value.zToA;
        if ((!rootData.getComponent().containsKey(aToZ)) ||
            (!rootData.getComponent().containsKey(zToA))) {
          return;
        }
        data.Box boxA = rootData.getComponent()[aToZ];
        data.Box boxZ = rootData.getComponent()[zToA];

        if ((rootData.criticalPath != null) &&
            rootData.criticalPath!.linkList.contains(value)) {
          paintX.strokeWidth = 3.0;
          paintX.color = Colors.red;
        } else {
          paintX.strokeWidth = 2.0;
          paintX.color = Colors.blue;
        }
        double xMin = boxA.x + boxA.size / 2;
        double xMax = boxZ.x + boxA.size / 2;
        double yMin = boxA.y + boxA.size / 2;
        double yMax = boxZ.y + boxA.size / 2;
        canvas.drawLine(Offset(xMin, yMin), Offset(xMax, yMax), paintX);

        String title = "w=${value.weight}";
        TextPainter textTitle = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            style: sampleTextStyle,
            text: title,
          ),
        )..layout();
        xMin = (xMin + xMax) / 2;
        yMin = (yMin + yMax) / 2;
        textTitle.paint(canvas, Offset(xMin, yMin));
      }
    }

    for (String x in component.keys) {
      var value = component[x];
      if (value is data.Box) {
        if (myCanvas.selectedBox == value) {
          paintX.color = Colors.pink;
        } else if ((rootData.criticalPath != null) &&
            rootData.criticalPath!.boxList.contains(value)) {
          paintX.color = Colors.orange;
        } else {
          paintX.color = Colors.grey;
        }
        var path = Path();
        path.moveTo(value.x, value.y);
        path.lineTo(value.x, value.y + value.size);
        path.lineTo(value.x + value.size, value.y + value.size);
        path.lineTo(value.x + value.size, value.y);
        path.close();
        canvas.drawPath(path, paintX);
        String title = value.nodeName;
        if (myCanvas.isMove && (myCanvas.selectedBox == value)) {
          title += " is move";
        }
        TextPainter textTitle = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            style: sampleTextStyle,
            text: title,
          ),
        )..layout();
        textTitle.paint(canvas, Offset(value.x, value.y + value.size + 1));
      }
    }
  }

  void paintMenu(
      Canvas canvas, Size size, Paint paintX, TextStyle sampleTextStyle) {
    paintX.strokeWidth = 1.0;
    double dx = myCanvas.menuItemList[0].xMin;
    double dy = myCanvas.menuItemList[0].yMin;

    List<TextPainter> textTitleList = [];
    double maxWidth = 0;
    for (MenuItem menuItem in myCanvas.menuItemList) {
      TextPainter textTitle = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          style: sampleTextStyle,
          text: menuItem.title,
        ),
      )..layout();
      textTitleList.add(textTitle);
      maxWidth = maxWidth < textTitle.width ? textTitle.width : maxWidth;
    }
    int i = -1;
    for (MenuItem menuItem in myCanvas.menuItemList) {
      i++;
      TextPainter textTitle = textTitleList[i];
      menuItem.xMin = dx;
      menuItem.yMin = dy;
      menuItem.xMax = dx + maxWidth + 4;
      menuItem.yMax = menuItem.yMin + textTitle.height + 4;
      dx = menuItem.xMin;
      dy = menuItem.yMax + 1;
      paintX.style = PaintingStyle.fill;
      paintX.color = Colors.white;
      var path = Path();
      path.moveTo(menuItem.xMin, menuItem.yMin);
      path.lineTo(menuItem.xMin, menuItem.yMax);
      path.lineTo(menuItem.xMax, menuItem.yMax);
      path.lineTo(menuItem.xMax, menuItem.yMin);
      path.close();
      canvas.drawPath(path, paintX);
      //
      paintX.style = PaintingStyle.stroke;
      paintX.color = Colors.grey;
      path = Path();
      path.moveTo(0, 0);
      path.moveTo(menuItem.xMin, menuItem.yMin);
      path.lineTo(menuItem.xMin, menuItem.yMax);
      path.lineTo(menuItem.xMax, menuItem.yMax);
      path.lineTo(menuItem.xMax, menuItem.yMin);
      path.close();
      canvas.drawPath(path, paintX);
      //
      textTitle.paint(canvas, Offset(menuItem.xMin + 2, menuItem.yMin + 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyItemDialog extends StatefulWidget {
  final data.RootData rootData;
  final data.Box selectedBox;
  final data.Box linkedBox;
  const MyItemDialog(
      {Key? key,
      required this.rootData,
      required this.selectedBox,
      required this.linkedBox})
      : super(key: key);

  @override
  createState() => _MyItemDialog();
}

class _MyItemDialog extends State<MyItemDialog> {
  final double min = 0;
  final double max = 400;
  double _number = 10;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    myController.text = _number.toInt().toString();
    return AlertDialog(
      title: const Text('Create Link'),
      content: Text(
          "From ${widget.selectedBox.nodeName} to ${widget.linkedBox.nodeName}"),
      actions: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Text("widget=${_number.toInt()}"),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                alignment: Alignment.center,
                width: 100,
                child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLines: null,
                    controller: myController))),
        GestureDetector(
            child: const Text('Update'),
            onTap: () {
              setState(() {
                _number = double.parse(myController.text);
                _number = _number < min
                    ? min
                    : max < _number
                        ? max
                        : _number;
                _number = _number.toInt().toDouble();
              });
            }),
        Slider(
          value: _number,
          min: min,
          max: max,
          onChanged: (value) {
            setState(() {
              _number = value;
              myController.text = _number.toInt().toString();
            });
          },
        ),
        GestureDetector(
            child: const Text('OK'),
            onTap: () {
              widget.rootData.createLink(
                  widget.selectedBox, widget.linkedBox, _number.toInt());
              widget.rootData.changedData();
              //
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
