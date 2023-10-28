import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/MyApp.dart';
import 'src/RootData.dart';

void main() {
  RootData data = RootData();
  runApp(MaterialApp(
      home: MultiProvider(providers: [
    ChangeNotifierProvider<RootData>(
      create: (context) => data,
    ),
  ], child: const MyApp())));
}
