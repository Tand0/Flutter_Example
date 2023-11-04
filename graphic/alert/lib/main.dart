import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/MySelect.dart';
import 'src/NodeData.dart';

void main() {
  NodeData data = NodeData();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<NodeData>(
      create: (context) => data,
    ),
  ], child: MaterialApp(initialRoute: MySelect.callName, routes: data.route)));
}
