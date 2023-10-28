import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RootData.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static List<String> getColumn() {
    return ["name", "param1", "param2", "param3", "param4", "param5"];
  }

  List<DataCell> createTableRow(int columnLen, String name, RootData rootData) {
    List<DataCell>? target = [];
    int pos = 0;
    target.add(DataCell(Text(name)));
    for (String oneValue in rootData.lists[name]) {
      target.add(DataCell(Text(oneValue)));
      pos++;
      if (columnLen - 1 <= pos) {
        break;
      }
    }
    for (pos; pos < columnLen - 1; pos++) {
      target.add(const DataCell(Text("--")));
    }
    return target;
  }

  String generateNonce([int length = 5]) {
    const charset = 'ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
    final random = Random.secure();
    final randomStr =
        List.generate(length, (_) => charset[random.nextInt(charset.length)])
            .join();
    return randomStr;
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
            cells: createTableRow(column.length, nameList[index], rootData)));

    return Scaffold(
        appBar: AppBar(title: const Text("Table test")),
        body: Row(children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.create),
                label: Text('Create'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.delete),
                label: Text('Delete'),
              ),
            ],
            selectedIndex: null,
            onDestinationSelected: (index) {
              if (index == 0) {
                String name = generateNonce();
                List<String> values =
                    column.map((e) => generateNonce()).toList();
                rootData.addList(name, values);
                rootData.index = -1;
              } else {
                if ((0 <= rootData.index) &&
                    (rootData.index < nameList.length)) {
                  String name = nameList[rootData.index];
                  rootData.removeList(name);
                  rootData.index = -1;
                }
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
