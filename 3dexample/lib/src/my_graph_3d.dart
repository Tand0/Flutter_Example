import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'my_graph_caller.dart';

class MyGraph3D extends StatelessWidget {
  const MyGraph3D({Key? key}) : super(key: key);

  static const String callName = "/Graph3D";
  static const String _title = "3D sample";

  @override
  Widget build(BuildContext context) {
    var x = ModalRoute.of(context)!.settings.arguments;
    Widget me;
    String title = _title;
    if (x is MyGraphCaller3D) {
      me = CustomPaint(painter: _MyCustomPainter(x));
      title = x.title;
    } else {
      me = const Text('caller not found.');
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: SizedBox(
            width: double.infinity, height: double.infinity, child: me));
  }
}

class _MyCustomPainter extends CustomPainter {
  final MyGraphCaller3D myGraphCaller;
  _MyCustomPainter(this.myGraphCaller);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  //
  static const int size = 100;
  static int maxX = changeTo2D(size, size, 0).x.toInt();

  /// 元ネタ
  /// https://codezine.jp/article/detail/116
  ///
  /// プロットされる空間は 0,0,0--size,size,sizeなので
  /// 関数側を合わせてください
  @override
  void paint(Canvas g, Size sizeX) {
    final paintX = Paint();
    paintX.color = Colors.black;
    paintX.strokeWidth = 1.0;
    paintX.style = PaintingStyle.stroke;

    // 枠を引く
    const TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 12);
    List<List<dynamic>> lineList = [
      [Colors.grey, 0, 0, 0, 0, 1, 0],
      [Colors.grey, 0, 1, 0, 0, 1, 1],
      [Colors.grey, 0, 1, 0, 1, 1, 0],
      [Colors.black, 0, 0, 0, 0, 0, 1],
      [Colors.black, 0, 0, 0, 1, 0, 0],
      [Colors.black, 0, 0, 1, 1, 0, 1],
      [Colors.black, 0, 0, 1, 0, 1, 1],
      [Colors.black, 1, 1, 0, 1, 1, 1],
      [Colors.black, 0, 1, 1, 1, 1, 1],
      [Colors.black, 1, 0, 0, 1, 1, 0],
      [Colors.black, 1, 0, 1, 1, 0, 0],
      [Colors.black, 1, 0, 1, 1, 1, 1],
    ];
    //
    for (List<dynamic> line in lineList) {
      paintX.color = line[0];
      Point point1 = changeTo2D(line[1] * size, line[2] * size, line[3] * size);
      Point point2 = changeTo2D(line[4] * size, line[5] * size, line[6] * size);
      drawLine(g, sizeX, point1, point2, paintX);
    }
    //
    // Z軸値に応じて着色する
    for (int z = 0; z <= size; z++) {
      paintX.color = changeToColor(z * 100.0 / size);
      Point point1 = changeTo2D(0, 0 - 2, z.toDouble());
      Point point2 = changeTo2D(0, 0 - 10, z.toDouble());
      drawLine(g, sizeX, point1, point2, paintX);
    }

    //目盛を入れる
    for (int z = 0; z <= size; z += size ~/ 5) {
      Point point1 = changeTo2D(0, 0, z.toDouble());
      Point point2 = changeTo2D(0, 0 - 15, z.toDouble());
      paintX.color = Colors.black;
      drawLine(g, sizeX, point1, point2, paintX);
      double rz = z * (myGraphCaller.zMax - myGraphCaller.zMin) / size +
          myGraphCaller.zMin;
      drawString(g, sizeX, rz.toStringAsFixed(1), point2, -15, 5, textStyle);
    }
    for (int x = 0; x <= size; x += size ~/ 5) {
      Point point1 = changeTo2D(x, 0, 0);
      Point point2 = changeTo2D(x, 0 - 15, 0);
      paintX.color = Colors.black;
      drawLine(g, sizeX, point1, point2, paintX);
      double rx = x * (myGraphCaller.xMax - myGraphCaller.xMin) / size +
          myGraphCaller.xMin;
      drawString(g, sizeX, rx.toStringAsFixed(1), point2, -15, 0, textStyle);
    }
    for (int y = 0; y <= size; y += size ~/ 5) {
      Point point1 = changeTo2D(size, y, 0);
      Point point2 = changeTo2D(size + 15, y, 0);
      paintX.color = Colors.black;
      drawLine(g, sizeX, point1, point2, paintX);
      double ry = y * (myGraphCaller.yMax - myGraphCaller.yMin) / size +
          myGraphCaller.yMin;
      drawString(g, sizeX, ry.toStringAsFixed(1), point2, 0, 5, textStyle);
    }

    // x,y,z 文字を入れる
    Point pointX;
    pointX = changeTo2D(size ~/ 2, -15, 0);
    drawString(g, sizeX, "X-Axis", pointX, -30, 15, textStyle);
    pointX = changeTo2D(0, 0 - 15, size / 2);
    drawString(g, sizeX, "Z-Axis", pointX, -30, 0, textStyle);
    pointX = changeTo2D(size, size ~/ 2, 0);
    drawString(g, sizeX, "Y-Axis", pointX, 0, 30, textStyle);

    int step = 8;
    List<double> yMinList;
    List<double> yMaxList;
    // 着色
    // Xワイヤーフレーム
    paintX.strokeWidth = 1.0;
    yMinList = List<double>.generate(maxX + 1, (t) => double.maxFinite);
    yMaxList = List<double>.generate(maxX + 1, (t) => double.minPositive);
    for (int x = size - 1; 0 <= x; x--) {
      Point? pointNew;
      Point? pointOld;
      for (int y = size - 1; 0 <= y; y--) {
        double z = function(x.toDouble(), y.toDouble());
        if (pointOld == null) {
          pointNew = changeTo2D(x, y, z);
          pointOld = pointNew;
        } else {
          pointOld = pointNew;
          pointNew = changeTo2D(x, y, z);
        }
        //
        int index = pointNew.x.toInt();
        if (yMaxList[index] < pointNew.y) {
          yMaxList[index] = pointNew.y;
          paintX.color =
              (x % (size / step * 4) == 0) ? Colors.black45 : Colors.black12;
          drawLine(g, sizeX, pointOld!, pointNew, paintX);
        }
        if (pointNew.y <= yMinList[index]) {
          yMinList[index] = pointNew.y;
          paintX.color = changeToColor(z);
          drawLine(g, sizeX, pointOld!, pointNew, paintX);
        }
        //if (flag) {
        //  pointOld = null;
        //}
      }
    }
    // Yワイヤーフレーム
    yMinList = List<double>.generate(maxX + 1, (t) => double.maxFinite);
    yMaxList = List<double>.generate(maxX + 1, (t) => double.minPositive);
    for (int y = size; 0 <= y; y -= step) {
      Point? pointNew;
      Point? pointOld;
      for (int x = size; 0 <= x; x -= step) {
        double z = function(x.toDouble(), y.toDouble());
        if (pointOld == null) {
          pointNew = changeTo2D(x, y, z);
          pointOld = pointNew;
        } else {
          pointOld = pointNew;
          pointNew = changeTo2D(x, y, z);
        }
        int index = pointNew.x.toInt();
        if (yMaxList[index] <= pointNew.y) {
          yMaxList[index] = pointNew.y;
          paintX.color =
              (x % (size / step * 4) == 0) ? Colors.black45 : Colors.black12;
          drawLine(g, sizeX, pointOld!, pointNew, paintX);
          pointOld = pointNew;
        }
        if (pointNew.y <= yMinList[index]) {
          yMinList[index] = pointNew.y;
          paintX.color = changeToColor(z);
          drawLine(g, sizeX, pointOld!, pointNew, paintX);
        }
      }
    }
  }

  /// 関数のメソッド
  double function(double x, double y) {
    // x,y のスケール変換
    x = x * (myGraphCaller.xMax - myGraphCaller.xMin) / size +
        myGraphCaller.xMin;
    y = y * (myGraphCaller.yMax - myGraphCaller.yMin) / size +
        myGraphCaller.yMin;
    //
    double z;
    //
    // (1)
    z = myGraphCaller.caller3d(x, y);

    // (2)
    //z = 80;

    // (3)
    // x = x - 50;
    // y = y - 50;
    // z = 50 * math.cos(math.sqrt(x * x + y * y) / 10.0) + 50;

    // Z のスケール戻し変換
    z = z * size / (myGraphCaller.zMax - myGraphCaller.zMin) +
        myGraphCaller.zMin;
    return z;
  }

  /// 数値をカラーに変換するメソッド
  Color changeToColor(double z) {
    int a = 0xff;
    int d, r, g, b;

    z = z * 1.6;
    d = (z >= 0) ? (z.toInt() % 256) : 255 - ((-z).toInt() % 256);
    int m = d ~/ 42.667;
    switch (m) {
      //青→シアン
      case 0:
        r = 0;
        g = 6 * d;
        b = 255;
        break;
      //シアン→緑
      case 1:
        r = 0;
        g = 255;
        b = 255 - 6 * (d - 43);
        break;
      //緑→黄
      case 2:
        r = 6 * (d - 86);
        g = 255;
        b = 0;
        break;
      //黄→赤
      case 3:
        r = 255;
        g = 255 - 6 * (d - 129);
        b = 0;
        break;
      //赤→マゼンタ
      case 4:
        r = 255;
        g = 0;
        b = 6 * (d - 171);
        break;
      //マゼンタ→青
      case 5:
        r = 255 - 6 * (d - 214);
        g = 0;
        b = 255;
        break;
      default:
        r = 0;
        g = 0;
        b = 0;
        break;
    }
    return Color.fromARGB(a, r, g, b);
  }

  /// 角度をラジアン
  static double toRadians(int degree) {
    return degree * (math.pi / 180.0);
  }

  static const int theta = -40;
  static const int phi = 60;
  static final double sint = math.sin(toRadians(theta));
  static final double sinp = math.sin(toRadians(phi));
  static final double cost = math.cos(toRadians(theta));
  static final double cosp = math.cos(toRadians(phi));
  static final Point realMin = changeTo2D(0, -60, size + 80);
  static final Point realMax = changeTo2D(size + 30, size + 30, -80);

  /// 三次元座標を二次元座標
  static Point changeTo2D(int dx, int dy, double dz) {
    double x = -(sint * dx) + (cost * dy) + 1;
    double y = (cost * cosp * size + sinp * size) -
        (-(cost * cosp * dx) - (sint * cosp) * dy + (sinp * dz)) +
        1;

    if (x.toInt() < 0) {
      //x = 0;
    }

    return Point(x, y);
  }

  // 文字を書く
  void drawString(Canvas g, Size sizeX, String text, Point s, int width,
      int height, TextStyle textStyle) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        style: textStyle,
        text: text,
      ),
    )..layout();
    textPainter.paint(g, toOffset(s.append(width, height), sizeX));
  }

  /// 線を引く
  drawLine(Canvas g, Size sizeX, Point s, Point e, Paint paintX) {
    Offset os = toOffset(s, sizeX);
    Offset oe = toOffset(e, sizeX);
    g.drawLine(os, oe, paintX);
  }

  Offset toOffset(Point e, Size sizeX) {
    return Offset(toOffsetX(e.x, sizeX.width), toOffsetY(e.y, sizeX.height));
  }

  static int minX = 60;
  double toOffsetX(double x, double width) {
    return (x + minX) * width / (realMax.x - realMin.x);
  }

  double toOffsetY(double y, double height) {
    return y * height / (realMax.y - realMin.y);
  }
}

class Point {
  double x;
  double y;
  Point(this.x, this.y);
  Point append(int width, int height) {
    x = x + width;
    y = y + height;
    return this;
  }
}
