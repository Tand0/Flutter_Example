import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RootData.dart';
import 'MyData.dart';
import 'dart:convert';
import 'dart:math';

class MyGraph extends StatelessWidget {
  const MyGraph({Key? key}) : super(key: key);

  static const String callName = "/Graph";
  static const String title = "title";
  static const String xTitle = "xTitle";
  static const String yTitle = "yTitle";
  static const String xLine = "xLine";
  static const String yLine = "yLine";
  static const String xLog10 = "xLog10";
  static const String yLog10 = "yLog10";
  static const String group = "group";
  static const String point = "point";
  static const String strokeWidth = "strokeWidth";
  static const String color = "color";
  static const String text = "text";
  static const String line = "line";
  static const String plot = "plot";
  static const String spline = "spline";
  static const String fill = "fill";
  static const String arrowStart = "arrowStart";
  static const String arrowEnd = "arrowEnd";
  static List defaultValueLine = [
    {color: '0xff0000f0'},
    {strokeWidth: 1.0},
    {line: true}
  ];
  static List defaultValueArrow = [
    {color: '0xff0000ff'},
    {strokeWidth: 2.0},
    {line: true},
    {arrowStart: true},
    {arrowEnd: true},
  ];
  static const List defaultValueFill = [
    {color: '0xffff00ff'},
    {strokeWidth: 2.0},
    {fill: true},
  ];
  static const List defaultValueSpline = [
    {spline: 2},
    {color: '0xff00ff00'},
    {strokeWidth: 1.0},
    {fill: false},
    {plot: true}
  ];
  static const List defaultValueText = [
    {text: 'XXXX'},
    {color: '0xff000000'},
    {plot: false},
  ];

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    Map value = rootData.getRootRouteValue(context);
    String title = rootData.getRouteName(context);
    _MyCustomPainter me = _MyCustomPainter(value);
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: Row(children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.line_axis),
                label: Text('Create Line'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.line_style),
                label: Text('Create Arrow'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_box),
                label: Text('Add Box'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.data_exploration),
                label: Text('Create Spline'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.text_fields),
                label: Text('Create Text'),
              ),
            ],
            selectedIndex: null,
            onDestinationSelected: (index) {
              if (index == 0) {
                getTarget(context, rootData, defaultValueLine);
              } else if (index == 1) {
                getTarget(context, rootData, defaultValueArrow);
              } else if (index == 2) {
                getTarget(context, rootData, defaultValueFill);
              } else if (index == 3) {
                getTarget(context, rootData, defaultValueSpline);
              } else {
                getTarget(context, rootData, defaultValueText);
              }
            },
          ),
          Expanded(
              child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GestureDetector(
                      onTapUp: (details) {
                        //
                        double dx = details.localPosition.dx;
                        double dy = details.localPosition.dy;
                        me.setPoint(context, rootData, dx, dy);
                      },
                      child: CustomPaint(painter: me))))
        ]));
  }

  void getTarget(BuildContext context, RootData rootData, List defaultValue) {
    String name = rootData.get1stRouteName(context);
    var myData = rootData.lists[name];
    if (!myData.containsKey(MyGraph.group)) {
      myData[MyGraph.group] = [];
    }
    var groupData = myData[MyGraph.group];
    if (groupData is! List) {
      return;
    }
    //
    var deepCopyValue = json.decode(jsonEncode({MyGraph.group: defaultValue}));
    //
    groupData.add(deepCopyValue);
    String target = MyData.callName;
    target += '/';
    target += name;
    target += '/';
    target += MyGraph.group;
    target += '/';
    target += (groupData.length - 1).toString();
    target += '/';
    target += MyGraph.group;
    rootData.pushNamed(
        context, target, (BuildContext context) => const MyData());
  }
}

class _MyCustomPainter extends CustomPainter {
  final Map topValue;
  _MyCustomPainter(this.topValue) {
    //
  }

  void setPoint(
      BuildContext context, RootData rootData, double boxX, double boxY) {
    double realX = getBoxXToRealX(boxX);
    if (xLog10Flag) {
      realX = pow(10.0, realX / 10.0) as double;
    }
    double realY = getBoxYToRealY(boxY);
    if (yLog10Flag) {
      realY = pow(10.0, realY / 10.0) as double;
      // print("realY2=" + realY.toString());
    }
    var topValue = rootData.getTopRouteValue(context);
    if (topValue is List) {
      topValue.add({
        MyGraph.point: [realX, realY]
      });
      rootData.updateRouteValue();
    }
  }

  double get10Log10(double w) {
    return 10.0 * log(w) / ln10;
  }

  double getBoxXToRealX(double boxX) {
    return realXMin +
        (realXMax - realXMin) * (boxX - boxXMin) / (boxXMax - boxXMin);
  }

  double getBoxYToRealY(double boxY) {
    return realYMax -
        (realYMax - realYMin) * (boxY - boxYMin) / (boxYMax - boxYMin);
  }

  double getRealXToBoxX(double realX) {
    return boxXMin +
        (boxXMax - boxXMin) * (realX - realXMin) / (realXMax - realXMin);
  }

  double getRealYToBoxY(double realY) {
    return boxYMax -
        (boxYMax - boxYMin) * (realY - realYMin) / (realYMax - realYMin);
  }

  List<double> cleanUpDoubleList(var valueList) {
    List<double> result = [];
    if ((valueList == null) && (topValue is! List)) {
      return result;
    }
    for (dynamic value in valueList) {
      if (value is bool) {
        result.add(value ? 1.0 : 0);
      } else if (value is int) {
        result.add(value.toDouble());
      } else if (value is double) {
        result.add(value);
      }
    }
    return result;
  }

  int cleanUpInt(var value) {
    if (value is bool) {
      return value ? 1 : 0;
    } else if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value is String) {
      if (value.contains(RegExp('^0x'))) {
        return int.tryParse(value.substring(2), radix: 16) ?? 0;
      }
    }
    return 0;
  }

  double cleanUpDobule(var value) {
    if (value is bool) {
      return value ? 1.0 : 0.0;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    }
    return 0.0;
  }

  bool cleanUpBool(var value) {
    if (value is bool) {
      return value;
    } else if (value is int) {
      return value != 0;
    } else if (value is double) {
      return value != 0.0;
    } else if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return false;
  }

  //
  double boxXMin = 0;
  double boxXMax = 100;
  double boxYMin = 0;
  double boxYMax = 100;
  double realXMin = 0.0;
  double realXMax = 1.0;
  double realYMin = 0.0;
  double realYMax = 1.0;
  bool xLog10Flag = false;
  bool yLog10Flag = false;

  @override
  void paint(Canvas canvas, Size size) {
    const sampleTextStyle = TextStyle(color: Colors.black, fontSize: 12);
    final text = TextPainter(
      textDirection: TextDirection.ltr,
      text: const TextSpan(
        style: sampleTextStyle,
        text: 'musure text len',
      ),
    )..layout();

    //
    boxXMin = text.size.width;
    boxXMax = size.width - (text.size.width / 2);
    boxYMin = text.size.height * 3;
    boxYMax = size.height - (text.size.height * 5);
    realXMin = 0.0;
    realXMax = 1.0;
    realYMin = 0.0;
    realYMax = 1.0;

    final paintX = Paint();
    paintX.color = Colors.black38;
    paintX.strokeWidth = 1.0;
    //
    if (topValue.containsKey(MyGraph.xLog10)) {
      xLog10Flag = cleanUpBool(topValue[MyGraph.xLog10]);
    }
    if (topValue.containsKey(MyGraph.yLog10)) {
      yLog10Flag = cleanUpBool(topValue[MyGraph.yLog10]);
    }
    if (topValue.containsKey(MyGraph.xLine)) {
      //
      List<double> realList = cleanUpDoubleList(topValue[MyGraph.xLine]);
      int len = realList.length;
      if (2 <= len) {
        realXMin = realList[0];
        realXMax = realList[realList.length - 1];
        if (xLog10Flag) {
          realXMin = get10Log10(realXMin);
          realXMax = get10Log10(realXMax);
        }
        for (double realX in realList) {
          TextPainter text = TextPainter(
            textDirection: TextDirection.ltr,
            text: TextSpan(
              style: sampleTextStyle,
              text: realX.toString(),
            ),
          )..layout();
          if (xLog10Flag) {
            realX = get10Log10(realX);
          }
          double boxX = getRealXToBoxX(realX);
          double textX = boxX - (text.size.width / 2);
          double textY = boxYMax + 5;
          text.paint(canvas, Offset(textX, textY));
          canvas.drawLine(Offset(boxX, boxYMin), Offset(boxX, boxYMax), paintX);
        }
      }
    }
    if (topValue.containsKey(MyGraph.yLine)) {
      //
      List<double> realList = cleanUpDoubleList(topValue[MyGraph.yLine]);
      int len = realList.length;
      if (2 <= len) {
        realYMin = realList[0];
        realYMax = realList[realList.length - 1];
        if (yLog10Flag) {
          realYMin = get10Log10(realYMin);
          realYMax = get10Log10(realYMax);
        }
        for (double realY in realList) {
          TextPainter text = TextPainter(
            textDirection: TextDirection.ltr,
            text: TextSpan(
              style: sampleTextStyle,
              text: realY.toString(),
            ),
          )..layout();
          if (yLog10Flag) {
            realY = get10Log10(realY);
          }
          double boxY = getRealYToBoxY(realY);
          double textX = boxXMin - text.size.width - 5;
          double textY = boxY - (text.size.height / 2);
          var offset = Offset(textX, textY);
          text.paint(canvas, offset);
          canvas.drawLine(Offset(boxXMin, boxY), Offset(boxXMax, boxY), paintX);
        }
      }
    }
    if (topValue.containsKey(MyGraph.title)) {
      String title = topValue[MyGraph.title].toString();
      TextPainter text = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          style: sampleTextStyle,
          text: title.toString(),
        ),
      )..layout();
      double textX = (boxXMax - boxXMin) / 2 - (text.size.width / 2) + boxXMin;
      double textY = boxYMin - text.size.height * 2;
      var offset = Offset(textX, textY);
      text.paint(canvas, offset);
    }
    if (topValue.containsKey(MyGraph.xTitle)) {
      String title = topValue[MyGraph.xTitle].toString();
      TextPainter text = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          style: sampleTextStyle,
          text: title.toString(),
        ),
      )..layout();
      double textX = boxXMax - (text.size.width / 2);
      double textY = boxYMax + text.size.height + 5;
      text.paint(canvas, Offset(textX, textY));
      var offset = Offset(textX, textY);
      text.paint(canvas, offset);
    }
    if (topValue.containsKey(MyGraph.yTitle)) {
      String title = topValue[MyGraph.yTitle].toString();
      TextPainter text = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          style: sampleTextStyle,
          text: title.toString(),
        ),
      )..layout();
      double textX = boxXMin - text.size.width - 5;
      double textY = boxYMin - (text.size.height * 3 / 2);
      var offset = Offset(textX, textY);
      text.paint(canvas, offset);
    }
    if (topValue.containsKey(MyGraph.group)) {
      paintNext(canvas, size, topValue[MyGraph.group]);
    }
  }

  void paintNext(Canvas canvas, Size size, var value) {
    if (value is! List) {
      return;
    }
    //
    List<double> plotListX = [];
    List<double> plotListY = [];
    //
    // default setting
    List<String> messageList = [];
    bool plotFlag = true;
    bool lineFlag = false;
    bool fillFlag = false;
    int splineInt = 0;
    final paintX = Paint();
    paintX.color = Colors.black38;
    paintX.strokeWidth = 1.0;
    bool arrowStartFlag = false;
    bool arrowEndFlag = false;
    //

    for (var element in value) {
      if (element is! Map) {
        continue;
      }
      element.forEach((key, valueNext) {
        switch (key) {
          case MyGraph.plot:
            plotFlag = cleanUpBool(valueNext);
            break;
          case MyGraph.line:
            lineFlag = cleanUpBool(valueNext);
            break;
          case MyGraph.color:
            paintX.color = Color(cleanUpInt(valueNext));
            break;
          case MyGraph.strokeWidth:
            paintX.strokeWidth = cleanUpDobule(valueNext);
            break;
          case MyGraph.point:
            if ((valueNext is! List) || (valueNext.length < 2)) {
              break;
            }
            double realX = cleanUpDobule(valueNext[0]);
            if (xLog10Flag) {
              realX = get10Log10(realX);
            }
            double realY = cleanUpDobule(valueNext[1]);
            if (yLog10Flag) {
              realY = get10Log10(realY);
            }
            plotListX.add(realX);
            plotListY.add(realY);
            break;
          case MyGraph.text:
            messageList.add(valueNext.toString());
            break;
          case MyGraph.spline:
            splineInt = cleanUpInt(valueNext);
            break;
          case MyGraph.fill:
            fillFlag = cleanUpBool(valueNext);
            paintX.style = PaintingStyle.fill;
            break;
          case MyGraph.arrowStart:
            arrowStartFlag = cleanUpBool(valueNext);
            break;
          case MyGraph.arrowEnd:
            arrowEndFlag = cleanUpBool(valueNext);
            break;
          case MyGraph.group:
          default:
            break;
        }
      });
    }

    if (fillFlag && (1 < plotListX.length)) {
      var path = Path();
      path.moveTo(getRealXToBoxX(plotListX[0]), getRealYToBoxY(plotListY[0]));
      for (int i = 1; i < plotListX.length; i++) {
        double boxNewX = getRealXToBoxX(plotListX[i]);
        double boxNewY = getRealYToBoxY(plotListY[i]);
        path.lineTo(boxNewX, boxNewY);
      }
      path.close();
      canvas.drawPath(path, paintX);
    } else if (lineFlag && (1 < plotListX.length)) {
      double boxX = getRealXToBoxX(plotListX[0]);
      double boxY = getRealYToBoxY(plotListY[0]);
      for (int i = 1; i < plotListX.length; i++) {
        double boxNewX = getRealXToBoxX(plotListX[i]);
        double boxNewY = getRealYToBoxY(plotListY[i]);
        canvas.drawLine(Offset(boxX, boxY), Offset(boxNewX, boxNewY), paintX);
        boxX = boxNewX;
        boxY = boxNewY;
      }
    }

    if (arrowStartFlag && (1 < plotListX.length)) {
      double boxAX = getRealXToBoxX(plotListX[0]);
      double boxAY = getRealYToBoxY(plotListY[0]);
      double boxZX = getRealXToBoxX(plotListX[1]);
      double boxZY = getRealYToBoxY(plotListY[1]);
      if ((boxAX == boxZX) && (boxAY == boxZY)) {
        // pass
      } else {
        double dX = boxZX - boxAX;
        double dY = boxZY - boxAY;
        double angle = atan2(dY, dX) + pi;
        double arrowSize = paintX.strokeWidth * 8.0;
        double arrowAngle = 25.0 * pi / 180.0;
        final path = Path();
        path.moveTo(boxAX - arrowSize * cos(angle - arrowAngle),
            boxAY - arrowSize * sin(angle - arrowAngle));
        path.lineTo(boxAX, boxAY);
        path.lineTo(boxAX - arrowSize * cos(angle + arrowAngle),
            boxAY - arrowSize * sin(angle + arrowAngle));
        path.close();
        canvas.drawPath(path, paintX);
      }
    }

    if (arrowEndFlag && (1 < plotListX.length)) {
      double boxAX = getRealXToBoxX(plotListX[plotListX.length - 2]);
      double boxAY = getRealYToBoxY(plotListY[plotListY.length - 2]);
      double boxZX = getRealXToBoxX(plotListX[plotListX.length - 1]);
      double boxZY = getRealYToBoxY(plotListY[plotListY.length - 1]);
      if ((boxAX == boxZX) && (boxAY == boxZY)) {
        // pass
      } else {
        double dX = boxZX - boxAX;
        double dY = boxZY - boxAY;
        double angle = atan2(dY, dX);
        double arrowSize = paintX.strokeWidth * 8.0;
        double arrowAngle = 25.0 * pi / 180.0;
        final path = Path();
        path.moveTo(boxZX - arrowSize * cos(angle - arrowAngle),
            boxZY - arrowSize * sin(angle - arrowAngle));
        path.lineTo(boxZX, boxZY);
        path.lineTo(boxZX - arrowSize * cos(angle + arrowAngle),
            boxZY - arrowSize * sin(angle + arrowAngle));
        path.close();
        canvas.drawPath(path, paintX);
      }
    }

    if ((0 < splineInt) &&
        (splineInt <= 5) &&
        (splineInt + 1 < plotListX.length)) {
      try {
        LeastSquares calc = LeastSquares();
        calc.calc(plotListX, plotListY, splineInt);
        bool flag = false;
        double boxOldY = 0.0;
        for (double boxX = boxXMin; boxX < boxXMax; boxX++) {
          double realX = getBoxXToRealX(boxX);
          double realY;
          try {
            realY = calc.retrunXtoY(realX);
          } catch (e) {
            continue;
          }
          double boxY = getRealYToBoxY(realY);
          if (flag) {
            if ((boxYMin < boxY) && (boxY <= boxYMax)) {
              canvas.drawLine(
                  Offset(boxX - 1, boxOldY), Offset(boxX, boxY), paintX);
            }
          } else {
            flag = true;
          }
          boxOldY = boxY;
        }
      } catch (e) {
        //
      }
    }
    if (plotFlag) {
      for (int i = 0; i < plotListX.length; i++) {
        double boxX = getRealXToBoxX(plotListX[i]);
        double boxY = getRealYToBoxY(plotListY[i]);
        //
        var path = Path();
        path.moveTo(boxX - 3, boxY - 3);
        path.lineTo(boxX + 3, boxY - 3);
        path.lineTo(boxX + 3, boxY + 3);
        path.lineTo(boxX - 3, boxY + 3);
        path.close();
        canvas.drawPath(path, paintX);
      }
    }

    for (int i = 0; (i < messageList.length) && (i < plotListX.length); i++) {
      double boxX = getRealXToBoxX(plotListX[i]);
      double boxY = getRealYToBoxY(plotListY[i]);
      Color color = paintX.color;
      TextStyle sampleTextStyle = TextStyle(color: color, fontSize: 12);
      TextPainter text = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          style: sampleTextStyle,
          text: messageList[i],
        ),
      )..layout();
      text.paint(canvas, Offset(boxX, boxY));
    }

    for (var element in value) {
      if (element is! Map) {
        continue;
      }
      element.forEach((key, valueNext) {
        switch (key) {
          case MyGraph.group:
            paintNext(canvas, size, valueNext);
            break;
          default:
            break;
        }
      });
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LeastSquares {
  List<double> b = [];
  void calc(List<double> x, List<double> y, int m) {
    List<double> s = [];
    for (int j = 0; j < 2 * m + 1; j++) {
      double w = 0.0;
      for (double i in x) {
        w += pow(i, j);
      }
      s.add(w);
    }
    List<double> t = [];
    for (int j = 0; j < m + 1; j++) {
      double w = 0.0;
      for (int i = 0; i < x.length; i++) {
        w += pow(x[i], j) * y[i];
      }
      t.add(w);
    }
    List<List<double>> a = [];
    for (int i = 0; i < t.length; i++) {
      List<double> aa = [];
      a.add(aa);
      for (int j = 0; j < t.length; j++) {
        aa.add(s[i + j]);
      }
      aa.add(t[i]);
    }
    for (int k = 0; k < t.length; k++) {
      double p = a[k][k];
      for (int j = 0; j < t.length + 1; j++) {
        a[k][j] /= p;
      }
      for (int i = 0; i < t.length; i++) {
        if (i != k) {
          double d = a[i][k];
          for (int j = k; j < t.length + 1; j++) {
            a[i][j] -= d * a[k][j];
          }
        }
      }
    }
    b = [];
    for (int k = 0; k < a.length; k++) {
      b.add(a[k][a[k].length - 1]);
    }
  }

  double retrunXtoY(double px) {
    double py = 0.0;
    for (int k = 0; k < b.length; k++) {
      py += b[k] * pow(px, k);
    }
    return py;
  }
}
