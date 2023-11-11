import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'root_data.dart';

class MyUserTable extends StatelessWidget {
  const MyUserTable({super.key});

  static const String callName = "/UserTable";

  static List<String> getColumn() {
    return ["Name", "Delete", "Rename"];
  }

  List<DataCell> createTableRow(
      BuildContext context, RootData rootData, String name) {
    List<DataCell>? target = [];
    target.add(DataCell(Text(name)));
    target.add(DataCell(TextButton(
        onPressed: () {
          print("TODO");
        },
        child: Text(getColumn()[1]))));
    target.add(DataCell(TextButton(
        onPressed: () {
          print("TODO");
        },
        child: Text(getColumn()[2]))));
    return target;
  }

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    List<String> column = getColumn();

    List<DataRow> rowList = [];

    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.navigation),
            onPressed: () {
              showDialog<void>(
                  context: context,
                  builder: (_) {
                    return MyItemDialog(rootData: rootData);
                  });
            }),
        appBar: AppBar(
            title: const Text("Item select"),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
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

class MyItemDialog extends StatefulWidget {
  final RootData rootData;
  const MyItemDialog({required this.rootData, super.key});

  @override
  createState() => _MyItemDialog();
}

class _MyItemDialog extends State<MyItemDialog> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Dialog'),
      content: const Text('Please input type'),
      actions: <Widget>[
        Column(children: [
          Container(
              alignment: Alignment.centerLeft,
              width: 400,
              child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'User Name',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                  ],
                  controller: userNameController)),
          Container(
              alignment: Alignment.centerLeft,
              width: 400,
              child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                  ],
                  controller: passwordController)),
          GestureDetector(
            child: const Text('OK'),
            onTap: () {
              String userName = userNameController.text;
              String password = passwordController.text;

              // createUser
              widget.rootData
                  .createUser(userName, password, () => oK(), () => nG());

              Navigator.of(context).pop();
            },
          )
        ]),
      ],
    );
  }

  void oK() {
    showDialog<void>(
        context: context,
        builder: (_) {
          return const AlertDialogSample(message: "OK!");
        });
  }

  void nG() {
    showDialog<void>(
        context: context,
        builder: (_) {
          return const AlertDialogSample(message: "NG!");
        });
  }
}

class AlertDialogSample extends StatelessWidget {
  final String message;
  const AlertDialogSample({required this.message, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('MESSAGE'),
      content: Text(message),
      actions: <Widget>[
        GestureDetector(
          child: const Text('OK'),
          onTap: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
