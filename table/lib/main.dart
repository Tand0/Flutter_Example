import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/my_app.dart';
import 'src/root_data.dart';

void main() {
  RootData data = RootData();
  runApp(MaterialApp(
      home: MultiProvider(providers: [
    ChangeNotifierProvider<RootData>(
      create: (context) => data,
    ),
  ], child: const MyApp())));
}
