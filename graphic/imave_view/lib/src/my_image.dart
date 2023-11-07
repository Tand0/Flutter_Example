import 'package:flutter/material.dart';
import 'root_data.dart';

abstract class MyImage extends StatelessWidget {
  const MyImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var x = ModalRoute.of(context)!.settings.arguments;
    String title = "--";
    if (x is RouteData) {
      title = x.title;
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: getImage()));
  }

  Widget getImage();
}
