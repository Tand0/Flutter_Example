import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/my_app.dart';
import 'src/RootData.dart';

void main() {
  RootData data = RootData();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<RootData>(
      create: (context) => data,
    ),
  ], child: const MyApp()));
}
