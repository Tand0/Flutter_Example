import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/MyTable.dart';
import 'src/RootData.dart';

void main() {
  RootData data = RootData();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<RootData>(
      create: (context) => data,
    ),
  ], child: MaterialApp(initialRoute: MyApp.callName, routes: data.route)));
}
