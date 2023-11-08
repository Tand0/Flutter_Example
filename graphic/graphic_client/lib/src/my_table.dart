import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:table/src/my_graph.dart';
import 'root_data.dart';
import 'my_save.dart';
import 'my_data.dart';
import 'my_json.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class MyTable extends StatelessWidget {
  const MyTable({super.key});

  static const String callName = "/Table";

  static List<String> getColumn() {
    return ["Name", "Edit", "Delete", "Data", "Graphic"];
  }

  List<DataCell> createTableRow(
      BuildContext context, RootData rootData, String name) {
    List<DataCell>? target = [];
    target.add(DataCell(Text(name)));
    target.add(DataCell(TextButton(
        onPressed: () {
          showDialog<void>(
              context: context,
              builder: (_) {
                return MyItemDialog(rootData: rootData, max: 0, oldName: name);
              });
        },
        child: Text(getColumn()[1]))));
    target.add(DataCell(TextButton(
        onPressed: () {
          rootData.removeList(name);
        },
        child: Text(getColumn()[2]))));
    target.add(DataCell(TextButton(
        onPressed: () {
          String target = '${MyData.callName}/$name';
          rootData.pushNamed(
              context, target, (BuildContext context) => const MyData());
        },
        child: Text(getColumn()[3]))));
    target.add(DataCell(TextButton(
        onPressed: () {
          String target = '${MyGraph.callName}/$name/${MyGraph.group}';
          rootData.pushNamed(
              context, target, (BuildContext context) => const MyGraph());
        },
        child: Text(getColumn()[4]))));
    return target;
  }

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);

    List<String> column = getColumn();
    List<String> nameList = rootData.lists.keys.toList();

    List<DataRow> rowList = List<DataRow>.generate(
        nameList.length,
        (index) => DataRow(
            onSelectChanged: (selected) {
              rootData.index = index;
            },
            color: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (rootData.index == index) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              return null;
            }),
            cells: createTableRow(context, rootData, nameList[index])));

    return Scaffold(
        appBar: AppBar(title: const Text("Item select")),
        body: Row(children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.create),
                label: Text('Create'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.save),
                label: Text('Save'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.view_array),
                label: Text('View'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.policy),
                label: Text('Privacy Policy'),
              ),
            ],
            selectedIndex: null,
            onDestinationSelected: (index) {
              if (index == 0) {
                rootData.index = -1;
                showDialog<void>(
                    context: context,
                    builder: (_) {
                      return MyItemDialog(
                          rootData: rootData,
                          max: nameList.length,
                          oldName: '');
                    });
              } else if (index == 1) {
                rootData.pushNamed(context, MySave.callName,
                    (BuildContext context) => const MySave());
              } else if (index == 2) {
                rootData.pushNamed(context, MyJson.callName,
                    (BuildContext context) => const MyJson());
              } else {
                final url =
                    Uri.parse('https://github.com/Tand0/Flutter_Example/');
                launchUrl(url);
              }
            },
          ),
          Expanded(
              child: Container(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                      child: DataTable(
                          showCheckboxColumn: false,
                          columns: column
                              .map((e) => DataColumn(label: Text(e)))
                              .toList(),
                          rows: rowList))))
        ]));
  }
}

class MyItemDialog extends StatefulWidget {
  const MyItemDialog(
      {Key? key,
      required this.rootData,
      required this.oldName,
      required this.max})
      : super(key: key);
  final RootData rootData;
  final int max;
  final String oldName;

  @override
  createState() => _MyItemDialog();
}

class _MyItemDialog extends State<MyItemDialog> {
  final TextEditingController dialogController = TextEditingController();
  bool _flagX = false;
  bool _flagY = false;

  void _handleCheckboxX(bool? e) {
    setState(() {
      _flagX = (e == null) ? false : e;
    });
  }

  void _handleCheckboxY(bool? e) {
    setState(() {
      _flagY = (e == null) ? false : e;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.oldName == '') {
      dialogController.text = "Graph-${widget.max}";
    } else {
      dialogController.text = widget.oldName;
    }
    return AlertDialog(
      title: const Text('New Dialog'),
      content: const Text('Please input type'),
      actions: <Widget>[
        Row(children: [
          Container(
              alignment: Alignment.centerLeft,
              width: 200,
              child: TextField(inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
              ], controller: dialogController))
        ]),
        Row(children: [
          const Text("x log10"),
          Checkbox(
            activeColor: Colors.blue,
            value: _flagX,
            onChanged: (value) {
              _handleCheckboxX(value);
            },
          )
        ]),
        Row(children: [
          const Text("y log10"),
          Checkbox(
            activeColor: Colors.red,
            value: _flagY,
            onChanged: (value) {
              _handleCheckboxY(value);
            },
          )
        ]),
        GestureDetector(
          child: const Text('OK'),
          onTap: () {
            String name = dialogController.text;
            if (name == '') {
              name = "Graph-${widget.max}";
            }
            Map<String, dynamic> value;
            Map<String, dynamic> lists = widget.rootData.lists;
            if ((widget.oldName != '') &&
                (widget.oldName != name) &&
                (lists.containsKey(widget.oldName))) {
              value = lists[widget.oldName];
            } else {
              //
              // This is init data.
              Map<String, dynamic> defaultValue = {};
              defaultValue[MyGraph.group] = [];
              defaultValue[MyGraph.title] = name;
              defaultValue[MyGraph.xTitle] = "XXX";
              defaultValue[MyGraph.yTitle] = "YYY";
              if (_flagX) {
                defaultValue[MyGraph.xLine] = [0.0001, 0.001, 0.01, 0.1, 1.0];
                defaultValue[MyGraph.xLog10] = true;
              } else {
                defaultValue[MyGraph.xLine] = [0, 20, 40, 60, 80, 100];
                defaultValue[MyGraph.xLog10] = false;
              }
              if (_flagY) {
                defaultValue[MyGraph.yLine] = [0.0001, 0.001, 0.01, 0.1, 1.0];
                defaultValue[MyGraph.yLog10] = true;
              } else {
                defaultValue[MyGraph.yLine] = [0, 20, 40, 60, 80, 100];
                defaultValue[MyGraph.yLog10] = false;
              }
              //
              value = defaultValue;
            }
            //
            // deep copy
            value = json.decode(jsonEncode(value));
            widget.rootData.addList(name, value);
            //
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
