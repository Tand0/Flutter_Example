///
///
abstract class MyGraphCaller {
  String title;
  double xMin;
  double yMin;
  double xMax;
  double yMax;
  MyGraphCaller(this.title, this.xMin, this.xMax, this.yMin, this.yMax);
}

typedef Caller2D = double Function(double);

class MyGraphCaller2D extends MyGraphCaller {
  List<Caller2D> caller2dList;
  MyGraphCaller2D(super.title, super.xMin, super.xMax, super.yMin, super.yMax,
      this.caller2dList);
}

typedef Caller3D = double Function(double, double);

class MyGraphCaller3D extends MyGraphCaller {
  double zMin;
  double zMax;
  Caller3D caller3d;
  MyGraphCaller3D(super.title, super.xMin, super.xMax, super.yMin, super.yMax,
      this.zMin, this.zMax, this.caller3d);
}
