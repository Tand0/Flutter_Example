import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime _focused = DateTime.now();
DateTime? _selected = _focused;
final Map<DateTime, List> sampleEvents = {};
List<MenuItem> menuItemList = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ToDo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    _MyCustomPainter me = _MyCustomPainter();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(children: [
          Center(
              child: TableCalendar(
                  firstDay: DateTime.utc(0, 1, 1),
                  lastDay: DateTime.utc(2999, 12, 31),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selected, day);
                  },
                  onDaySelected: (selected, focused) {
                    if (!isSameDay(_selected, selected)) {
                      setState(() {
                        menuItemList = [];
                        _selected = selected;
                        _focused = focused;
                      });
                    }
                  },
                  eventLoader: (date) {
                    return sampleEvents[date] ?? [];
                  },
                  focusedDay: _focused,
                  calendarFormat: CalendarFormat.month,
                  onFormatChanged: (format) => {})),
          Expanded(
              child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GestureDetector(
                      onTapUp: (details) {
                        //
                        double dx = details.localPosition.dx;
                        double dy = details.localPosition.dy;
                        setState(() {
                          me.setPoint(context, _selected, dx, dy);
                        });
                      },
                      child: CustomPaint(painter: me))))
        ]));
  }
}

typedef MenuAction = void Function();

class MenuItem {
  String title;
  double xMax;
  double xMin;
  double yMin;
  double yMax;
  MenuAction? menuAction;
  MenuItem(
      this.title, this.xMin, this.xMax, this.yMin, this.yMax, this.menuAction);
}

class _MyCustomPainter extends CustomPainter {
  double xMax = 0;
  double yMax = 0;
  double pointX = 0;
  double pointY = 0;
  List<String>? menuList;
  _MyCustomPainter();

  void setPoint(
      BuildContext context, DateTime? dateTime, double dx, double dy) {
    if (dateTime == null) {
      return;
    }
    if (_selected == null) {
      return;
    }

    if (menuItemList.isNotEmpty) {
      //
      //
      //
      menuItemList = [];
    } else {
      DateTime selectDateTime =
          DateTime.utc(_selected!.year, _selected!.month, _selected!.day);
      List eventList = [];
      if (sampleEvents.containsKey(selectDateTime)) {
        eventList = sampleEvents[selectDateTime]!;
      }
      eventList.add([dx, dx + 1, dy, dy + 1, "bob", "xxxx"]);
      sampleEvents[selectDateTime] = eventList;
      //
      menuItemList = [
        MenuItem("Cut", dx, dx + 1, dy, dy + 1, null),
        MenuItem("Copy", dx, dx + 1, dy, dy + 1, null),
        MenuItem("Paste", dx, dx + 1, dy, dy + 1, null),
      ];
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    //
    xMax = size.width;
    yMax = size.height;
    final paintX = Paint();
    paintX.color = Colors.black38;
    paintX.strokeWidth = 1.0;
    //
    canvas.drawLine(Offset(xMax / 3, 0), Offset(xMax / 3, yMax), paintX);
    canvas.drawLine(
        Offset(xMax * 2 / 3, 0), Offset(xMax * 2 / 3, yMax), paintX);
    //
    if (_selected == null) {
      menuItemList = [];
      return;
    }
    String title = "${_selected!.year}/${_selected!.month}/${_selected!.day}";
    const sampleTextStyle = TextStyle(color: Colors.black, fontSize: 12);
    TextPainter text = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        style: sampleTextStyle,
        text: title,
      ),
    )..layout();
    text.paint(canvas, const Offset(0, 0));
    DateTime selectDateTime =
        DateTime.utc(_selected!.year, _selected!.month, _selected!.day);
    if (sampleEvents.containsKey(selectDateTime)) {
      List eventList = sampleEvents[selectDateTime]!;
      for (List event in eventList) {
        final double dx = event[0].toDouble();
        final double dy = event[2].toDouble();
        final String name = event[4];
        title = event[5];
        TextPainter textName = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            style: sampleTextStyle,
            text: name,
          ),
        )..layout();
        event[3] = dy + text.height;
        //
        TextPainter textTitle = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            style: sampleTextStyle,
            text: title,
          ),
        )..layout();
        double dxMax = dx + textTitle.width;
        double dyMax = dy + textName.height + textTitle.height;
        event[1] = dxMax;
        event[3] = dyMax;
        //
        paintX.style = PaintingStyle.fill;
        paintX.color = Colors.yellow;
        var path = Path();
        path.moveTo(dx, dy);
        path.lineTo(dx, dyMax);
        path.lineTo(dxMax, dyMax);
        path.lineTo(dxMax, dy);
        path.close();
        canvas.drawPath(path, paintX);
        //
        textName.paint(canvas, Offset(dx, dy));
        textTitle.paint(canvas, Offset(dx, dy + textName.height));
      }
    }
    if (menuItemList.isNotEmpty) {
      double dx = menuItemList[0].xMin;
      double dy = menuItemList[0].yMin;

      for (MenuItem menuItem in menuItemList) {
        TextPainter textTitle = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            style: sampleTextStyle,
            text: menuItem.title,
          ),
        )..layout();
        menuItem.xMin = dx;
        menuItem.yMin = dy;
        menuItem.xMax = menuItem.xMin + 100;
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
