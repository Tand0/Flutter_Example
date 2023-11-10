import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'root_data.dart';

class MyTodo extends StatefulWidget {
  const MyTodo({Key? key}) : super(key: key);

  static const callName = "/todo";

  @override
  State<MyTodo> createState() => _MyTodo();
}

class _MyTodo extends State<MyTodo> {
  static const title = "ToDo list";

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    _MyCustomPainter me = _MyCustomPainter(rootData);
    return Scaffold(
        appBar: AppBar(
            title: const Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: Column(children: [
          Center(
              child: TableCalendar(
                  firstDay: DateTime.utc(0, 1, 1),
                  lastDay: DateTime.utc(2999, 12, 31),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(rootData.selected, day);
                  },
                  onDaySelected: (selected, focused) {
                    if (!isSameDay(rootData.selected, selected)) {
                      rootData.menuItemList = [];
                      rootData.selected = selected;
                      rootData.focused = focused;
                      back();
                    }
                  },
                  eventLoader: (date) {
                    return rootData.sampleEvents[date] ?? [];
                  },
                  focusedDay: rootData.focused,
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
                          me.setPoint(context, rootData.selected, dx, dy, back);
                        });
                      },
                      child: CustomPaint(painter: me))))
        ]));
  }

  void back() {
    setState(() {});
  }
}

class _MyCustomPainter extends CustomPainter {
  double xMax = 0;
  double yMax = 0;
  double pointX = 0;
  double pointY = 0;
  List<String>? menuList;
  RootData rootData;
  _MyCustomPainter(this.rootData);

  void cut(DateTime selectDateTime, List? event, MenuItem item,
      MyTodoCallback back) {
    if (!rootData.sampleEvents.containsKey(selectDateTime)) {
      return;
    }
    if (event == null) {
      return;
    }
    rootData.sampleEvents[selectDateTime]?.remove(event);
    copy(selectDateTime, event, item, back);
  }

  void copy(DateTime selectDateTime, List? event, MenuItem item,
      MyTodoCallback back) {
    if (event != null) {
      return;
    }
    Future(() async {
      final data = ClipboardData(text: event?[4]);
      await Clipboard.setData(data);
      back();
    });
  }

  void past(DateTime selectDateTime, List? event, MenuItem item,
      MyTodoCallback back) {
    Future(() async {
      final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
      String? copyText = clipboard?.text;
      copyText ??= "xxx";
      List eventList = [];
      if (rootData.sampleEvents.containsKey(selectDateTime)) {
        eventList = rootData.sampleEvents[selectDateTime]!;
      }
      double dx = item.xMin;
      double dy = item.yMin;
      eventList.add([dx, dx + 1, dy, dy + 1, rootData.userName, copyText]);
      rootData.sampleEvents[selectDateTime] = eventList;
      back();
    });
  }

  void setPoint(BuildContext context, DateTime? dateTime, double dx, double dy,
      MyTodoCallback callBack) {
    if (dateTime == null) {
      return;
    }
    if (rootData.selected == null) {
      return;
    }

    if (rootData.menuItemList.isNotEmpty) {
      //
      for (MenuItem item in rootData.menuItemList) {
        if ((item.xMin < dx) &&
            (dx < item.xMax) &&
            (item.yMin < dy) &&
            (dy < item.yMax)) {
          item.menuAction(item.selectDateTime, item.event, item, callBack);
        }
      }
      //
      //
      rootData.menuItemList = [];
    } else {
      DateTime selectDateTime = DateTime.utc(rootData.selected!.year,
          rootData.selected!.month, rootData.selected!.day);
      bool flag = true;
      if (rootData.sampleEvents.containsKey(selectDateTime)) {
        List eventList = rootData.sampleEvents[selectDateTime]!;
        for (List event in eventList) {
          if ((event[0] < dx) &&
              (dx < event[1]) &&
              (event[2] < dy) &&
              (dy < event[3])) {
            // hit!
            rootData.menuItemList = [
              MenuItem("Cut", dx, dx + 1, dy, dy + 1, selectDateTime, event,
                  (p1, p2, p3, p4) => cut(p1, p2, p3, p4), callBack),
              MenuItem("Copy", dx, dx + 1, dy, dy + 1, selectDateTime, event,
                  (p1, p2, p3, p4) => copy(p1, p2, p3, p4), callBack),
            ];
            flag = false;
          }
        }
      }
      if (flag) {
        rootData.menuItemList = [
          MenuItem("Paste", dx, dx + 1, dy, dy + 1, selectDateTime, null,
              (p1, p2, p3, p4) => past(p1, null, p3, p4), callBack),
        ];
      }
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
    if (rootData.selected == null) {
      rootData.menuItemList = [];
      return;
    }
    String title =
        "${rootData.selected!.year}/${rootData.selected!.month}/${rootData.selected!.day}";
    const sampleTextStyle = TextStyle(color: Colors.black, fontSize: 12);
    TextPainter text = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        style: sampleTextStyle,
        text: title,
      ),
    )..layout();
    text.paint(canvas, const Offset(0, 0));
    DateTime selectDateTime = DateTime.utc(rootData.selected!.year,
        rootData.selected!.month, rootData.selected!.day);
    if (rootData.sampleEvents.containsKey(selectDateTime)) {
      List eventList = rootData.sampleEvents[selectDateTime]!;
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
        if (dx < size.width / 3) {
          paintX.color = Colors.yellow;
        } else if (dx < size.width * 2 / 3) {
          paintX.color = Colors.pink;
        } else {
          paintX.color = Colors.black12;
        }
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
    if (rootData.menuItemList.isNotEmpty) {
      double dx = rootData.menuItemList[0].xMin;
      double dy = rootData.menuItemList[0].yMin;

      List<TextPainter> textTitleList = [];
      double maxWidth = 0;
      for (MenuItem menuItem in rootData.menuItemList) {
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
      for (MenuItem menuItem in rootData.menuItemList) {
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
