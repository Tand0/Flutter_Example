import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_graph_caller.dart';
import 'my_graph_3d.dart';
import 'my_graph_2d.dart';
import 'root_data.dart';
import 'dart:math' as math;

class MySelect extends StatelessWidget {
  const MySelect({super.key});

  static const String callName = "/";

  @override
  Widget build(BuildContext context) {
    RootData nodeData = Provider.of<RootData>(context, listen: true);
    List<MyGraphCaller> callerList = [
      MyGraphCaller3D("z=10", 0, 100, 0, 100, 0, 100, (x, y) => 10),
      MyGraphCaller3D("z=50", 0, 100, 0, 100, 0, 100, (x, y) => 50),
      MyGraphCaller3D(
          "math.cos(math.sqrt(x * x + y * y) / 10.0)",
          -100,
          100,
          -100,
          100,
          -1,
          1,
          (x, y) => math.cos(math.sqrt(x * x + y * y) / 10.0)),
      MyGraphCaller3D(
          "0 or 1",
          -5,
          5,
          -5,
          5,
          0,
          1.5,
          (x, y) =>
              (((x < -3) || (3 < x)) || ((y < -3) || (3 < y))) ? 0.0 : 1.0),
      MyGraphCaller3D("2 + x * x + 2 * x * y + 3", -2, 2, -2, 2, 2, 24,
          (x, y) => 2 + x * x + 2 * x * y + 3),
      MyGraphCaller3D(
          "(2.0 * x * x + y * y) * math.exp(-(2 * x * x + y * y))",
          -2,
          2,
          -2,
          2,
          0,
          0.5,
          (x, y) => (2.0 * x * x + y * y) * math.exp(-(2 * x * x + y * y))),
      MyGraphCaller2D("2d x=y,2x, x^2", -2, 2, -2, 2,
          [(x) => x, (x) => 2 * x, (x) => x * x]),
      MyGraphCaller2D("2d y=a^x", -4, 4, 0, 10, [
        (x) => math.pow(2.0, x) as double,
        (x) => math.pow(3.0, x) as double,
        (x) => math.pow(0.5, x) as double
      ]),
      MyGraphCaller2D("2d y=x, y=2^x, y=log x", -8, 8, -8, 8, [
        (x) => x,
        (x) => math.pow(2.0, x) as double,
        (x) => x <= 0 ? 0 : math.log(x) / math.ln2
      ]),
      MyGraphCaller2D("2d y=1/(1 + exp(-x))", -10, 10, -1.5, 1.5,
          [(x) => 1 / (1 + math.exp(-x))]),
      MyGraphCaller2D(
          "2d y=(exp(x) - exp(-x))/(exp(x) + exp(-x))",
          -10,
          10,
          -1.5,
          1.5,
          [(x) => (math.exp(x) - math.exp(-x)) / (math.exp(x) + math.exp(-x))]),
      MyGraphCaller2D("2d ReLU", -10, 10, -10, 10, [(x) => x <= 0 ? 0 : x]),
      MyGraphCaller2D("2d x=y", -10, 10, -10, 10, [(x) => x]),
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
