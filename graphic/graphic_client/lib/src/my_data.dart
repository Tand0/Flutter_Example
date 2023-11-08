import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'root_data.dart';
import 'my_graph.dart';

class MyData extends StatefulWidget {
  const MyData({Key? key}) : super(key: key);

  static const String callName = "/Data";

  @override
  // ignore: library_private_types_in_public_api
  _MyData createState() => _MyData();
}

class _MyData extends State<MyData> {
  static List<String> column = [
    "Index",
    "Name",
    "Type",
    "Delete",
    "Change",
    "Data"
  ];

  final Map<String, TextEditingController> myController = {};

  List<DataCell> createTableRow(BuildContext context, RootData rootData,
      var value, List nameList, int index) {
    List<DataCell>? target = [];
    if (nameList.length <= index) {
      target.add(DataCell(TextButton(
          onPressed: () {
            showDialog<void>(
                context: context,
                builder: (_) {
                  return NewDialog(rootData: rootData, value: value);
                });
          },
          child: const Text("Add"))));
      target.add(const DataCell(Text("--")));
      if (rootData.getLastRouteName(context) == MyGraph.group) {
        target.add(DataCell(TextButton(
            onPressed: () {
              String callName = MyGraph.callName;
              callName += rootData.getCutCallNameRouteName(context);
              rootData.pushNamed(
                  context, callName, (BuildContext context) => const MyGraph());
            },
            child: const Text('grafic'))));
      } else {
        target.add(const DataCell(Text("--")));
      }
      target.add(const DataCell(Text("--")));
      target.add(const DataCell(Text("--")));
      target.add(const DataCell(Text("--")));
      return target;
    }

    String name = nameList[index];
    Object nameIndex = (value is Map) ? name : index;

    target.add(DataCell(Text(index.toString())));
    target.add(DataCell(Text(nameIndex.toString())));

    final String type = (value[nameIndex] is Map)
        ? "Map"
        : (value[nameIndex] is List)
            ? "List"
            : (value[nameIndex] is bool)
                ? "bool"
                : (value[nameIndex] is double)
                    ? "double"
                    : (value[nameIndex] is int)
                        ? "int"
                        : "Text";
    target.add(DataCell(Text(type)));

    // delete
    target.add(DataCell(TextButton(
        onPressed: () {
          if (value is Map) {
            value.remove(nameList[index]);
          } else {
            value.removeAt(index);
          }
          rootData.updateRouteValue();
        },
        child: Text(column[3]))));

    // change
    target.add(DataCell(TextButton(
        onPressed: () {
          //
          if ((value[nameIndex] is Map) || (value[nameIndex] is List)) {
            String target = '${rootData.getRouteName(context)}/$nameIndex';
            rootData.pushNamed(
                context, target, (BuildContext context) => const MyData());
          } else {
            String? text = myController[name]?.text;
            if (text != null) {
              if (value[nameIndex] is bool) {
                value[nameIndex] = text.toLowerCase() == "true";
              } else if (value[nameIndex] is int) {
                value[nameIndex] = int.parse(text);
              } else if (value[nameIndex] is double) {
                value[nameIndex] = double.parse(text);
              } else if (value[nameIndex] is String) {
                value[nameIndex] = text;
              }
              rootData.updateRouteValue();
            }
          }
        },
        child: Text(column[4]))));

    if ((value[nameIndex] is! Map) && (value[nameIndex] is! List)) {
      setState(() {
        myController[name] = TextEditingController();
        myController[name]?.text = value[nameIndex].toString();
      });

      //
      if (value[nameIndex] is bool) {
        target.add(DataCell(Container(
            alignment: Alignment.centerLeft,
            width: 200,
            child: TextField(controller: myController[name]))));
      } else if ((value[nameIndex] is int) || (value[nameIndex] is double)) {
        target.add(DataCell(Container(
            alignment: Alignment.centerLeft,
            width: 400,
            child: TextField(
                keyboardType: TextInputType.number,
                controller: myController[name]))));
      } else {
        target.add(DataCell(Container(
            alignment: Alignment.centerLeft,
            width: 400,
            child: TextField(controller: myController[name]))));
      }
    } else if (name == MyGraph.group) {
      target.add(DataCell(TextButton(
          onPressed: () {
            String callName = MyGraph.callName;
            callName += rootData.getCutCallNameRouteName(context);
            callName += '/';
            callName += MyGraph.group;
            rootData.pushNamed(
                context, callName, (BuildContext context) => const MyGraph());
          },
          child: const Text('grafic'))));
    } else if (value[nameIndex] is Map) {
      Map valueData = value[nameIndex];
      String text = type;
      for (String key in valueData.keys) {
        text = key;
        text += '/';
        text += valueData[key].toString();
        if (31 < text.length) {
          text = text.substring(0, 31 - 3);
          text += '...';
        }
        break;
      }
      if (2 <= valueData.length) {
        text += "  ...";
      }
      target.add(DataCell(Text(text)));
    } else if (value[nameIndex] is List) {
      List valueData = value[nameIndex];
      String text = type;
      for (var key in valueData) {
        text = key.toString();
        break;
      }
      if (2 <= valueData.length) {
        text += " ...";
      }
      target.add(DataCell(Text(text)));
    } else {
      target.add(DataCell(Text(type)));
    }
    return target;
  }

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);

    var value = rootData.getTopRouteValue(context);
    List nameList = (value is Map)
        ? value.keys.toList()
        : (value is List)
            ? List<String>.generate(value.length, (index) => index.toString())
                .toList()
            : [];

    List<DataRow> rowList = List<DataRow>.generate(
        nameList.length + 1,
        (index) => DataRow(
            cells: createTableRow(context, rootData, value, nameList, index)));

    return Scaffold(
        appBar: AppBar(
          title: Text(rootData.getRouteName(context)),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
            alignment: Alignment.topLeft,
            child: SingleChildScrollView(
                child: DataTable(
                    showCheckboxColumn: false,
                    columns:
                        column.map((e) => DataColumn(label: Text(e))).toList(),
                    rows: rowList))));
  }
}

class NewDialog extends StatelessWidget {
  NewDialog({Key? key, required this.rootData, required this.value})
      : super(key: key);
  final RootData rootData;
  final dynamic value;
  final TextEditingController dialogController = TextEditingController();

  void creatValue(RootData rootData, var value, var type) {
    String name = dialogController.text;
    if (value is Map) {
      value[name] = type;
      rootData.updateRouteValue();
    } else if (value is List) {
      value.add(type);
      rootData.updateRouteValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    int max = (value is Map) ? (value as Map).length : (value as List).length;
    dialogController.text = "any_$max";
    return AlertDialog(
      title: const Text('New Dialog'),
      content: const Text('Please input type'),
      actions: <Widget>[
        Container(
            alignment: Alignment.centerLeft,
            width: 200,
            child: TextField(controller: dialogController)),
        SimpleDialogOption(
            child: const Text('List'),
            onPressed: () {
              creatValue(rootData, value, []);
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: const Text('Map'),
            onPressed: () {
              creatValue(rootData, value, {});
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: const Text('bool'),
            onPressed: () {
              creatValue(rootData, value, true);
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: const Text('int'),
            onPressed: () {
              creatValue(rootData, value, 0);
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: const Text('double'),
            onPressed: () {
              creatValue(rootData, value, 0.1);
              Navigator.of(context).pop();
            }),
        SimpleDialogOption(
            child: const Text('String'),
            onPressed: () {
              creatValue(rootData, value, "text");
              Navigator.of(context).pop();
            }),
      ],
    );
  }
}
