import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  RootData data = RootData();
  data.setRoute(MyApp.name, (BuildContext context) => const MyApp());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<RootData>(
      create: (context) => data,
    ),
  ], child: MaterialApp(initialRoute: MyApp.name, routes: data.route)));
}

class RootData with ChangeNotifier {
  final Map<String, WidgetBuilder> _route = {};

  void setRoute(String name, WidgetBuilder builder) {
    if (!_route.containsKey(name)) {
      _route[name] = builder;
    }
  }

  Map<String, WidgetBuilder> get route => _route;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String name = "Next";

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    return GestureDetector(
      child: const Text('next'),
      onTap: () {
        rootData.setRoute(
            MyAppNext.name, (BuildContext context) => const MyAppNext());
        Navigator.of(context).pushNamed(MyAppNext.name);
      },
    );
  }
}

class MyAppNext extends StatelessWidget {
  const MyAppNext({super.key});

  static const String name = "Back";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Text('back'),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
