import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RootData.dart';

class MyException implements IOException {
  String cause;
  MyException(this.cause);
}

class MyJson extends StatefulWidget {
  const MyJson({Key? key}) : super(key: key);

  static const String callName = "/Json";
  @override
  // ignore: library_private_types_in_public_api
  _MyJson createState() => _MyJson();
}

class _MyJson extends State<MyJson> {
  final myController = TextEditingController();

  void save(BuildContext context, RootData rootData) {
    String text = myController.text;
    final object = json.decode(text);
    if ((object == null) || (object is! Map)) {
      return;
    }
    rootData.lists.clear();
    object.forEach((key, value) {
      rootData.lists[key] = value;
    });
    rootData.updateRouteValue();
  }

  void load(BuildContext context, RootData rootData) {
    setState(() {
      myController.text =
          const JsonEncoder.withIndent('    ').convert(rootData.lists);
    });
  }

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    //
    load(context, rootData);
    //
    return Scaffold(
        appBar: AppBar(
          title: const Text("Display Json"),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
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
        ]));
  }
}
