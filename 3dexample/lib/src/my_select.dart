import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_graph_caller.dart';
import 'my_graph_3d.dart';
import 'my_graph_2d.dart';
import 'root_data.dart';
import 'dart:math' as math;

class MyGraphCallerFlat extends MyGraphCaller3D {
  MyGraphCallerFlat() {
    title = "z=10";
  }
  @override
  double call(double x, double y) {
    return 10;
  }
}

class MyGraphCallerFlat2 extends MyGraphCaller3D {
  MyGraphCallerFlat2() {
    title = "z=80";
  }
  @override
  double call(double x, double y) {
    return 80;
  }
}

class MyGraphCallerMath extends MyGraphCaller3D {
  MyGraphCallerMath() {
    title = "math.cos(math.sqrt(x * x + y * y) / 10.0)";
    xMin = -100;
    xMax = 100;
    yMin = -100;
    yMax = 100;
    zMin = -1;
    zMax = 1;
  }
  @override
  double call(double x, double y) {
    return math.cos(math.sqrt(x * x + y * y) / 10.0);
  }
}

class MyGraphCaller0od1 extends MyGraphCaller3D {
  MyGraphCaller0od1() {
    title = "0 or 1";
    xMin = -5;
    xMax = 5;
    yMin = -5;
    yMax = 5;
    zMin = 0;
    zMax = 1.5;
  }

  @override
  double call(double x, double y) {
    if (((x < -3) || (3 < x)) || ((y < -3) || (3 < y))) {
      return 0.0;
    }
    return 1.0;
  }
}

class MyGraphCallerX2p2XYp3 extends MyGraphCaller3D {
  MyGraphCallerX2p2XYp3() {
    title = "2 + x * x + 2 * x * y + 3";
    xMin = -2;
    xMax = 2;
    yMin = -2;
    yMax = 2;
    zMin = 2;
    zMax = 24;
  }

  @override
  double call(double x, double y) {
    return 2 + x * x + 2 * x * y + 3;
  }
}

class MyGraphCallerExp extends MyGraphCaller3D {
  MyGraphCallerExp() {
    title = "(2.0 * x * x + y * y) * math.exp(-(2 * x * x + y * y))";
    xMin = -2;
    xMax = 2;
    yMin = -2;
    yMax = 2;
    zMin = 0;
    zMax = 0.5;
  }

  @override
  double call(double x, double y) {
    return (2.0 * x * x + y * y) * math.exp(-(2 * x * x + y * y));
  }
}

class MyGraphCaller2DXtoY extends MyGraphCaller2D {
  MyGraphCaller2DXtoY() {
    title = "2d x=y,2x, x^2";
    xMin = -2;
    xMax = 2;
    yMin = -2;
    yMax = 2;
  }

  @override
  List<double> call(double x) {
    return [x, 2 * x, x * x];
  }
}

class MyGraphCaller2DExp extends MyGraphCaller2D {
  MyGraphCaller2DExp() {
    title = "2d y=a^x";
    xMin = -4;
    xMax = 4;
    yMin = 0;
    yMax = 10;
  }

  @override
  List<double> call(double x) {
    return [
      math.pow(2.0, x) as double,
      math.pow(3.0, x) as double,
      math.pow(0.5, x) as double
    ];
  }
}

class MyGraphCaller2DLog extends MyGraphCaller2D {
  MyGraphCaller2DLog() {
    title = "2d y=x, y=2^x, y=log x";
    xMin = -8;
    xMax = 8;
    yMin = -8;
    yMax = 8;
  }

  @override
  List<double> call(double x) {
    return [x, math.pow(2.0, x) as double, x <= 0 ? 0 : math.log(x) / math.ln2];
  }
}

class MyGraphCallerSigmoid extends MyGraphCaller2D {
  MyGraphCallerSigmoid() {
    title = "2d y=1/(1 + exp(-x))";
    xMin = -10;
    xMax = 10;
    yMin = -1.5;
    yMax = 1.5;
  }

  @override
  List<double> call(double x) {
    return [1 / (1 + math.exp(-x))];
  }
}

class MySelect extends StatelessWidget {
  const MySelect({super.key});

  static const String callName = "/";

  @override
  Widget build(BuildContext context) {
    RootData nodeData = Provider.of<RootData>(context, listen: true);
    List<MyGraphCaller> callerList = [
      MyGraphCallerFlat(),
      MyGraphCallerFlat2(),
      MyGraphCaller0od1(),
      MyGraphCallerX2p2XYp3(),
      MyGraphCallerMath(),
      MyGraphCallerExp(),
      MyGraphCaller2DXtoY(),
      MyGraphCaller2DExp(),
      MyGraphCaller2DLog(),
      MyGraphCallerSigmoid()
    ];
    List<GestureDetector> widgetList = [];
    for (MyGraphCaller caller in callerList) {
      widgetList.add(GestureDetector(
          child: Text(caller.title),
          onTap: () {
            nodeData.pushNamed(
                context,
                caller is MyGraphCaller2D
                    ? MyGraph2D.callName
                    : MyGraph3D.callName,
                (BuildContext context) => caller is MyGraphCaller2D
                    ? const MyGraph2D()
                    : const MyGraph3D(),
                caller);
          }));
    }

    return Scaffold(
        appBar: AppBar(title: const Text("3D Sample List")),
        body: Center(child: Column(children: widgetList)));
  }
}
