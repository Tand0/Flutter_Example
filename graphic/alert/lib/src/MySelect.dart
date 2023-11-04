import 'package:alert/src/MyGraph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NodeData.dart';
import 'MyJson.dart';
import 'MyAlarm.dart';

class MySelect extends StatelessWidget {
  const MySelect({super.key});

  static const String callName = "/";

  @override
  Widget build(BuildContext context) {
    NodeData nodeData = Provider.of<NodeData>(context, listen: true);

    return Scaffold(
        appBar: AppBar(title: const Text(MySelect.callName)),
        body: Center(
            child: Column(children: [
          GestureDetector(
              child: const Text('Graphic', style: TextStyle(fontSize: 24)),
              onTap: () {
                nodeData.pushNamed(context, MyGraph.callName,
                    (BuildContext context) => const MyGraph());
              }),
          GestureDetector(
              child: const Text('Alarm', style: TextStyle(fontSize: 24)),
              onTap: () {
                nodeData.pushNamed(context, MyAlarm.callName,
                    (BuildContext context) => const MyAlarm());
              }),
          GestureDetector(
              child: const Text('Json', style: TextStyle(fontSize: 24)),
              onTap: () {
                nodeData.pushNamed(context, MyJson.callName,
                    (BuildContext context) => const MyJson());
              }),
          GestureDetector(
              child:
                  const Text('Privacy Policy', style: TextStyle(fontSize: 24)),
              onTap: () {
                final url =
                    Uri.parse('https://github.com/Tand0/Flutter_Example/');
                launchUrl(url);
              }),
        ])));
  }
}
