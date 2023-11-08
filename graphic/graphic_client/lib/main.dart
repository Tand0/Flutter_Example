import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/my_table.dart';
import 'src/root_data.dart';

void main() {
  RootData data = RootData();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<RootData>(
      create: (context) => data,
    ),
  ], child: MaterialApp(initialRoute: MyTable.callName, routes: data.route)));
}
