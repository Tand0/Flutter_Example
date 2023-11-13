import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'root_data.dart';

class MyUserTable extends StatelessWidget {
  const MyUserTable({super.key});

  static const String callName = "/UserTable";

  static List<String> getColumn() {
    return ["Name", "Delete"];
  }

  List<DataRow> createDataRow(BuildContext context, RootData rootData) {
    return rootData.otherUserNameList
        .map((e) => DataRow(cells: createDataCell(context, rootData, e)))
        .toList();
  }

  List<DataCell> createDataCell(
      BuildContext context, RootData rootData, String name) {
    List<DataCell>? target = [];
    target.add(DataCell(Text(name)));
    if (((name == rootData.userName) || ('root' == rootData.userName)) &&
        (name != rootData.userName)) {
      target.add(DataCell(TextButton(
          onPressed: () {
            rootData.deletetUser(name);
          },
          child: Text(getColumn()[1]))));
    } else {
      target.add(const DataCell(Text('--')));
    }
    return target;
  }

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    List<String> column = getColumn();

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
                child: FutureBuilder<List?>(
                    future: rootData.getUser(),
                    builder:
                        (BuildContext context, AsyncSnapshot<List?> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text('Image loading...');
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return DataTable(
                                showCheckboxColumn: false,
                                columns: column
                                    .map((e) => DataColumn(label: Text(e)))
                                    .toList(),
                                rows: createDataRow(context, rootData));
                          }
                      }
                    }))));
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
              Future(() async {
                try {
                  // createUser
                  await widget.rootData.createUser(userName, password);
                } catch (e) {
                  nG();
                }
              });
              Navigator.of(context).pop();
            },
          )
        ]),
      ],
    );
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
