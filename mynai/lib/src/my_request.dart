import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'root_data.dart';

class MyRequest extends StatefulWidget {
  const MyRequest({super.key});

  static const String callName = "/Request";
  static const String title = "RequestData";

  @override
  createState() => _MyRequest();
}

class _MyRequest extends State<MyRequest> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    myController.text = rootData.getJsonString();
    String title = "${rootData.getTargetKey()} Req";
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              alignment: Alignment.centerLeft,
              width: 800,
              child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: myController)),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
              onPressed: () {
                rootData.nextAction(
                    context, rootData.getTargetKey(), myController.text);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              child: const Text('Go action!'))
        ])));
  }
}
