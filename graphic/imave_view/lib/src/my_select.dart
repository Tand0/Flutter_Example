import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_image_web.dart';
import 'my_image_asset.dart';
import 'my_image_canvas_asset.dart';
import 'root_data.dart';

class MySelect extends StatelessWidget {
  const MySelect({super.key});

  static const String callName = "/";

  @override
  Widget build(BuildContext context) {
    RootData rootData = Provider.of<RootData>(context, listen: true);
    List<RouteData> callerList = [
      RouteData("/ImageWeb", "Image Web",
          (BuildContext context) => const MyImageWeb()),
      RouteData("/ImageAsset", "Image Asset",
          (BuildContext context) => const MyImageAsset()),
      RouteData("/ImageCanvas", "Image Canvas",
          (BuildContext context) => const MyImageCanvasAsset()),
    ];
    List<GestureDetector> widgetList = [];
    for (RouteData caller in callerList) {
      widgetList.add(GestureDetector(
          child: Text(caller.title),
          onTap: () {
            rootData.pushNamed(
                context, caller.callName, caller.builder, caller);
          }));
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Sample List")),
        body: Center(child: Column(children: widgetList)));
  }
}
