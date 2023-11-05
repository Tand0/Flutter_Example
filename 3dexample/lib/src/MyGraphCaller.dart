///
///
abstract class MyGraphCaller {
  String _title = "3D sample";
  double _xMin = 0;
  double _yMin = 0;
  double _xMax = 100;
  double _yMax = 100;

  get title => _title;
  set title(x) {
    _title = x;
  }

  get xMin => _xMin;
  set xMin(x) {
    _xMin = x;
  }

  get yMin => _yMin;
  set yMin(a) {
    _yMin = a;
  }

  get xMax => _xMax;
  set xMax(a) {
    _xMax = a;
  }

  get yMax => _yMax;
  set yMax(a) {
    _yMax = a;
  }
}

abstract class MyGraphCaller2D extends MyGraphCaller {
  List<double> call(double x);
}

abstract class MyGraphCaller3D extends MyGraphCaller {
  double _zMin = 0;
  double _zMax = 100;

  get zMin => _zMin;
  set zMin(a) {
    _zMin = a;
  }

  get zMax => _zMax;
  set zMax(a) {
    _zMax = a;
  }

  double call(double x, double y);
}
