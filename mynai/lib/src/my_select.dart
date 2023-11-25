import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'root_data.dart';
import 'my_request.dart';

class MySelect extends StatelessWidget {
  const MySelect({super.key});

  static const String title = "My select";
  static const String callName = "/Select";

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];

    RootData root = Provider.of<RootData>(context, listen: true);

    widgetList.add(single(context, root, RootData.subscription));
    widgetList.add(single(context, root, RootData.suggest));
    widgetList.add(single(context, root, RootData.genearteImage));

    return Scaffold(
        appBar: AppBar(
            title: const Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: Center(child: Column(children: widgetList)));
  }

  Widget single(BuildContext context, RootData root, String title) {
    const sampleTextStyle = TextStyle(color: Colors.black, fontSize: 24);
    return GestureDetector(
        child: Text(title, style: sampleTextStyle),
        onTap: () {
          root.pushNamed(context, MyRequest.callName,
              (BuildContext context) => const MyRequest(), title);
        });
  }
}
