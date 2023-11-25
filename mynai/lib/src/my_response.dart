import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'root_data.dart';

class MyResponse extends StatefulWidget {
  const MyResponse({super.key});

  static const String callName = "/Response";
  static const String title = "ResponseData";

  @override
  createState() => _MyResponse();
}

class _MyResponse extends State<MyResponse> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);

    var response = rootData.getResponse();
    List<Widget> rowList = [];

    if (response == null) {
      myController.text = "null";
      rowList.add(const Text("null"));
    } else if (response is Image) {
      rowList.add(response);
    } else {
      myController.text = response.toString();
      rowList.add(Container(
          alignment: Alignment.centerLeft,
          width: 800,
          child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: myController)));
    }

    String title = "${rootData.getTargetKey()} Res";
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: SingleChildScrollView(child: Column(children: rowList)));
  }
}
