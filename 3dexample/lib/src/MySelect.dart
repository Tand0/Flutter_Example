import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MyGraph.dart';
import 'RootData.dart';
import 'dart:math' as math;

class MyGraphCallerFlat extends MyGraphCaller {
  @override
  double call(double x, double y) {
    return 10;
  }
}

class MyGraphCallerFlat2 extends MyGraphCaller {
  @override
  double call(double x, double y) {
    return 80;
  }
}

class MyGraphCallerMath extends MyGraphCaller {
  @override
  double call(double x, double y) {
    x = x - 50;
    y = y - 50;
    return 50 * math.cos(math.sqrt(x * x + y * y) / 10.0) + 50;
  }
}

class MyGraphCaller0od1 extends MyGraphCaller {
  MyGraphCaller0od1() {
    xMin = -5;
    xMax = 5;
    yMin = -5;
    yMax = 5;
    zMin = 0;
    zMax = 2;
  }

  @override
  double call(double x, double y) {
    if (((x < -3) || (3 < x)) || ((y < -3) || (3 < y))) {
      return 0.0;
    }
    return 1.0;
  }
}

class MySelect extends StatelessWidget {
  const MySelect({super.key});

  static const String callName = "/";

  @override
  Widget build(BuildContext context) {
    RootData nodeData = Provider.of<RootData>(context, listen: true);
    return Scaffold(
        appBar: AppBar(title: const Text("3D Sample List")),
        body: Center(
            child: Column(children: [
          GestureDetector(
              child: const Text('Flat 3D', style: TextStyle(fontSize: 24)),
              onTap: () {
                nodeData.pushNamed(
                    context,
                    MyGraph.callName,
                    (BuildContext context) => const MyGraph(),
                    MyGraphCallerFlat());
              }),
          GestureDetector(
              child: const Text('Flat 3D-2', style: TextStyle(fontSize: 24)),
              onTap: () {
                nodeData.pushNamed(
                    context,
                    MyGraph.callName,
                    (BuildContext context) => const MyGraph(),
                    MyGraphCallerFlat2());
              }),
          GestureDetector(
              child:
                  const Text('Flat 3D complex', style: TextStyle(fontSize: 24)),
              onTap: () {
                nodeData.pushNamed(
                    context,
                    MyGraph.callName,
                    (BuildContext context) => const MyGraph(),
                    MyGraphCallerMath());
              }),
          GestureDetector(
              child:
                  const Text('Flat 3D 0 or 1', style: TextStyle(fontSize: 24)),
              onTap: () {
                nodeData.pushNamed(
                    context,
                    MyGraph.callName,
                    (BuildContext context) => const MyGraph(),
                    MyGraphCaller0od1());
              }),
        ])));
  }
}
