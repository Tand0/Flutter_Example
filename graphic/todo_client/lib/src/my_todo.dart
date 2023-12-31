import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'root_data.dart';
import 'my_user_table.dart';

class MyTodo extends StatefulWidget {
  const MyTodo({Key? key}) : super(key: key);

  static const callName = "/Todo";

  @override
  State<MyTodo> createState() => _MyTodo();
}

class _MyTodo extends State<MyTodo> {
  static const title = "ToDo list";
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool jsonFlag = false;

  Column myTableCalendar(RootData rootData) {
    _MyCustomPainter me = _MyCustomPainter(rootData);

    return Column(children: [
      Center(
          child: TableCalendar(
              firstDay: DateTime.utc(rootData.selected!.year - 10, 1, 1),
              lastDay: DateTime.utc(rootData.selected!.year + 10, 12, 31),
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
              onPageChanged: (focusedDay) {
                rootData.focused = focusedDay;
                setState(() {
                  Future(() async {
                    await rootData.getEvent(focusedDay);
                  });
                });
              },
              eventLoader: (date) {
                return rootData.myEvents[date] ?? [];
              },
              focusedDay: rootData.focused,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              })),
      Expanded(
          child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: jsonFlag
                  ? MyJson(rootData: rootData)
                  : GestureDetector(
                      onTapUp: (details) {
                        //
                        double dx = details.localPosition.dx;
                        double dy = details.localPosition.dy;
                        setState(() {
                          me.setPoint(context, rootData.selected, dx, dy, back);
                        });
                      },
                      child: CustomPaint(painter: me))))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
            title: const Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.toggle_off),
                  onPressed: () => {
                        setState(() {
                          jsonFlag = !jsonFlag;
                        })
                      }),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => {
                  rootData.pushNamed(context, MyUserTable.callName,
                      (BuildContext context) => const MyUserTable(), null)
                },
              )
            ]),
        body: FutureBuilder<void>(
            future: rootData.getEvent(rootData.selected),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Image loading...');
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return myTableCalendar(rootData);
                  }
              }
            }));
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
    if (!rootData.myEvents.containsKey(selectDateTime)) {
      return;
    }
    if (event == null) {
      return;
    }
    for (int i = 0; i < rootData.myEvents[selectDateTime]!.length; i++) {
      List indexIvent = rootData.myEvents[selectDateTime]![i];
      if ((indexIvent[0] == event[0]) &&
          (indexIvent[1] == event[1]) &&
          (indexIvent[2] == event[2]) &&
          (indexIvent[3] == event[3])) {
        rootData.myEvents[selectDateTime]?.removeAt(i);
        break;
      }
    }
    //
    rootData.postEvent(selectDateTime);
    back();
    copy(selectDateTime, event, item, back);
  }

  void copy(DateTime selectDateTime, List? event, MenuItem item,
      MyTodoCallback back) {
    if (event == null) {
      return;
    }
    Future(() async {
      String text = event[5];
      Clipboard.setData(ClipboardData(text: text));
    });
  }

  void past(DateTime selectDateTime, List? event, MenuItem item,
      MyTodoCallback back) {
    Future(() async {
      final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
      String? copyText = clipboard?.text;
      copyText ??= "xxx";
      List eventList = [];
      if (rootData.myEvents.containsKey(selectDateTime)) {
        eventList = rootData.myEvents[selectDateTime]!;
      }
      double dx = item.xMin;
      double dy = item.yMin;
      eventList.add([dx, dx + 1, dy, dy + 1, rootData.userName, copyText]);
      rootData.myEvents[selectDateTime] = eventList;

      //
      rootData.postEvent(selectDateTime);
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
      if (rootData.myEvents.containsKey(selectDateTime)) {
        List eventList = rootData.myEvents[selectDateTime]!;
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
    List eventList = [];
    if (rootData.myEvents.containsKey(selectDateTime)) {
      eventList.addAll(rootData.myEvents[selectDateTime]!);
    }
    if (rootData.otherEvents.containsKey(selectDateTime)) {
      eventList.addAll(rootData.otherEvents[selectDateTime]!);
    }
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
      double dxMax = dx + textTitle.width + 2;
      double dyMax = dy + textName.height + textTitle.height + 2;
      event[1] = dxMax;
      event[3] = dyMax;
      //
      paintX.style = PaintingStyle.fill;
      if (rootData.userName != name) {
        paintX.color = Colors.black12;
      } else if (dx < size.width / 3) {
        paintX.color = Colors.lightBlue;
      } else if (dx < size.width * 2 / 3) {
        paintX.color = Colors.yellow;
      } else {
        paintX.color = Colors.black26;
      }
      var path = Path();
      path.moveTo(dx, dy + textName.height);
      path.lineTo(dx, dyMax);
      path.lineTo(dxMax, dyMax);
      path.lineTo(dxMax, dy + textName.height);
      path.close();
      canvas.drawPath(path, paintX);
      //
      textName.paint(canvas, Offset(dx, dy));
      textTitle.paint(canvas, Offset(dx, dy + textName.height));
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

class MyJson extends StatefulWidget {
  final RootData rootData;
  const MyJson({required this.rootData, Key? key}) : super(key: key);

  @override
  createState() => _MyJson();
}

class _MyJson extends State<MyJson> {
  final myController = TextEditingController();

  void save(BuildContext context, RootData rootData) {
    DateTime selectDateTime = DateTime.utc(widget.rootData.selected!.year,
        widget.rootData.selected!.month, widget.rootData.selected!.day);
    String text = myController.text;
    final object = json.decode(text);
    widget.rootData.myEvents[selectDateTime] = object;
  }

  void load(BuildContext context, RootData rootData) {
    DateTime selectDateTime = DateTime.utc(widget.rootData.selected!.year,
        widget.rootData.selected!.month, widget.rootData.selected!.day);
    if (widget.rootData.myEvents.containsKey(selectDateTime)) {
      List eventList = widget.rootData.myEvents[selectDateTime]!;
      myController.text =
          const JsonEncoder.withIndent('    ').convert(eventList);
    } else {
      myController.text = "{}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    //
    load(context, rootData);
    //
    return Row(children: [
      NavigationRail(
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.get_app),
            label: Text('Save'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.upload),
            label: Text('Load'),
          ),
        ],
        selectedIndex: null,
        onDestinationSelected: (index) {
          if (index == 0) {
            save(context, rootData);
          } else {
            load(context, rootData);
          }
        },
      ),
      Container(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
              child: Container(
                  alignment: Alignment.centerLeft,
                  width: 800,
                  child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: myController))))
    ]);
  }
}
