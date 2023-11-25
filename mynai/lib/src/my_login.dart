import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'root_data.dart';

class MyLogin extends StatelessWidget {
  MyLogin({super.key});

  static const callName = "/";

  final _editingController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NovelAI Client APP',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Username',
                  ),
                  controller: _editingController),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                controller: _passController,
                obscureText: true,
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  String userName = _editingController.text;
                  String userCommuinity = _passController.text;
                  rootData.startLogin(
                      context, rootData, userName, userCommuinity);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                child: const Text('ENTER'),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                  onPressed: () {
                    Future(() async {
                      final url = Uri.parse('https://novelai.net/');
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    });
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('Create user'))
            ],
          ),
        ),
      ),
    );
  }
}
