import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'NodeData.dart';

class MyAlarm extends StatefulWidget {
  const MyAlarm({super.key});

  static const String callName = "/Table";

  @override
  createState() => _MyAlarm();
}

class _MyAlarm extends State<MyAlarm> {
  static final List<String> column = [
    "DateTime",
    "IP",
    "Severity",
    "Component",
    "Value",
    "Delete"
  ];

  NodeData nodeData = NodeData();
  final int timer = 10;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: timer), (_) {
      doTimer();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void doTimer() {
    nodeData.updateAlarm();
  }

  List<DataCell> createTableRow(BuildContext context, Alarm alarm) {
    List<DataCell>? target = [];

    target.add(DataCell(Text(alarm.getDateTime())));
    target.add(DataCell(Text(alarm.ip)));
    target.add(DataCell(Text(alarm.getSeverity())));
    target.add(DataCell(Text(alarm.componentName)));
    target.add(DataCell(Text(alarm.value)));

    target.add(DataCell(TextButton(
        onPressed: () {
          nodeData.removeAlarm(alarm);
        },
        child: Text(column[5]))));
    return target;
  }

  @override
  Widget build(BuildContext context) {
    nodeData = Provider.of<NodeData>(context, listen: true);

    List<DataRow> rowList = List<DataRow>.generate(
        nodeData.getAlarmSize(),
        (index) => DataRow(
            color: MaterialStateProperty.resolveWith((states) {
              return nodeData.getAlarm(index).getAlarmColor();
            }),
            cells: createTableRow(context, nodeData.getAlarm(index))));

    return Scaffold(
        appBar: AppBar(
            title: const Text(MyAlarm.callName),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: SingleChildScrollView(
            child: DataTable(
                showCheckboxColumn: false,
                columns: column.map((e) => DataColumn(label: Text(e))).toList(),
                rows: rowList)));
  }
}
