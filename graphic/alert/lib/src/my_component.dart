import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'node_data.dart';

class MyComponent extends StatefulWidget {
  const MyComponent({super.key});

  static const String callName = "/Component";

  @override
  // ignore: library_private_types_in_public_api
  _MyComponent createState() => _MyComponent();
}

class _MyComponent extends State<MyComponent> {
  static List<String> column = ["Index", "Name", "Type", "Data"];

  final Map<String, TextEditingController> myController = {};

  void save(
      NodeData nodeData, Component component, List<List<dynamic>> jsonTable) {
    Map<String, dynamic> xx = {};
    for (List<dynamic> target in jsonTable) {
      String key = target[1];
      var oldValue = target[2];
      String newValueString = myController[key]?.text ?? '';
      if (oldValue is bool) {
        xx[key] = newValueString.toLowerCase() == 'true';
      } else if (oldValue is double) {
        xx[key] = double.tryParse(newValueString);
      } else if (oldValue is int) {
        xx[key] = int.tryParse(newValueString);
      } else {
        xx[key] = newValueString;
      }
    }
    component.fromJsonTable(xx);
    nodeData.notifyListeners();
  }

  void load(NodeData nodeData) {
    nodeData.notifyListeners();
  }

  List<DataCell> createTableRow(BuildContext context, NodeData nodeData,
      List<List<dynamic>> jsonTable, int index) {
    List<DataCell>? target = [];
    List<dynamic> value = jsonTable[index];

    target.add(DataCell(Text(index.toString())));
    target.add(DataCell(Text(value[0].toString())));
    var type = value[0];
    final String typeString = (type is Map)
        ? "Map"
        : (type is List)
            ? "List"
            : (type is bool)
                ? "bool"
                : (type is double)
                    ? "double"
                    : (type is int)
                        ? "int"
                        : "Text";
    target.add(DataCell(Text(typeString)));

    String name = value[1];
    myController[name] = TextEditingController();
    var inputData = value[2];
    myController[name]?.text = inputData.toString();
    if (inputData is bool) {
      target.add(DataCell(Container(
          alignment: Alignment.centerLeft,
          width: 400,
          child: TextField(controller: myController[name]))));
    } else if (inputData is double) {
      target.add(DataCell(Container(
          alignment: Alignment.centerLeft,
          width: 400,
          child: TextField(
              keyboardType: TextInputType.number,
              controller: myController[name]))));
    } else if (inputData is int) {
      target.add(DataCell(Container(
          alignment: Alignment.centerLeft,
          width: 400,
          child: TextField(
              keyboardType: TextInputType.number,
              controller: myController[name]))));
    } else if (inputData is String) {
      target.add(DataCell(Container(
          alignment: Alignment.centerLeft,
          width: 400,
          child: TextField(controller: myController[name]))));
    } else {
      target.add(const DataCell(Text('Unkown')));
    }
    return target;
  }

  @override
  Widget build(BuildContext context) {
    final NodeData nodeData = Provider.of<NodeData>(context, listen: true);

    final String componentId = nodeData.get1stRouteName(context);
    Component component = nodeData.getComponent(componentId);
    String title = component.name;

    List<List<dynamic>> jsonTable = component.toJsonTable();

    List<DataRow> rowList = List<DataRow>.generate(
        jsonTable.length,
        (index) => DataRow(
            cells: createTableRow(context, nodeData, jsonTable, index)));

    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Row(children: [
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
                save(nodeData, component, jsonTable);
              } else {
                load(nodeData);
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
