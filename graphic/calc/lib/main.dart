import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyChart(),
    );
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

class MyChart extends StatelessWidget {
  const MyChart({super.key});

  @override
  Widget build(BuildContext context) {
    List<double> x = [
      -3 + 10,
      -2 + 10,
      -1 + 10,
      0 + 10,
      1 + 10,
      2 + 10,
      3 + 10
    ];
    List<double> y = [
      5 + 10,
      -2 + 10,
      -3 + 10,
      -1 + 10,
      1 + 10,
      4 + 10,
      5 + 10
    ];
    List<LineChartBarData> bar = [];
    List<FlSpot> flspot = [];
    for (int i = 0; i < x.length; i++) {
      flspot.add(FlSpot(x[i].toDouble(), y[i].toDouble()));
    }
    bar.add(LineChartBarData(spots: flspot));
    //
    double xMin = x[0];
    double xMax = x[x.length - 1];
    double xStep = (xMax - xMin) / 100;
    LeastSquares obj = LeastSquares();
    List<Color> colors = [
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.cyan
    ];
    for (int m = 1; m < 5; m++) {
      obj.calc(x, y, m);
      List<FlSpot> flspot = [];
      double px = xMin;
      while (px <= xMax) {
        double py = obj.retrunXtoY(px);
        flspot.add(FlSpot(px, py));
        px += xStep;
      }
      bar.add(LineChartBarData(color: colors[m], spots: flspot));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Code Sample'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: LineChart(
          LineChartData(lineBarsData: bar),
        ),
      ),
    );
  }
}
