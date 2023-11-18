import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'root_data.dart';
import 'my_json.dart';
import 'my_canvas.dart';

class MySelect extends StatelessWidget {
  const MySelect({super.key});

  static const String title = "My Canvas";
  static const String callName = "/";

  @override
  Widget build(BuildContext context) {
    RootData nodeData = Provider.of<RootData>(context, listen: true);
    const sampleTextStyle = TextStyle(color: Colors.black, fontSize: 20);
    List<Widget> widgetList = [];
    widgetList.add(GestureDetector(
        child: const Text(MyJson.title, style: sampleTextStyle),
        onTap: () {
          nodeData.pushNamed(context, MyJson.callName,
              (BuildContext context) => const MyJson());
        }));

    widgetList.add(GestureDetector(
        child: const Text(MyCanvas.title, style: sampleTextStyle),
        onTap: () {
          nodeData.pushNamed(context, MyCanvas.callName,
              (BuildContext context) => const MyCanvas());
        }));

    return Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: Center(child: Column(children: widgetList)));
  }
}
