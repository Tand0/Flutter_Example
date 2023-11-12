import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_todo.dart';
import 'my_login_failed.dart';
import 'root_data.dart';

class MyLogin extends StatelessWidget {
  MyLogin({super.key});

  static const callName = "/";

  final _editingController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final RootData rootData = Provider.of<RootData>(context, listen: true);
    _editingController.text = rootData.userName;

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.displayLarge,
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
                  rootData.userName = _editingController.text;
                  rootData.userCommuinity = _passController.text;
                  rootData.startLogin(
                      () => rootData.pushNamed(context, MyTodo.callName,
                          (BuildContext context) => const MyTodo(), null),
                      () => rootData.pushNamed(
                          context,
                          MyLoginFailed.callName,
                          (BuildContext context) => const MyLoginFailed(),
                          null));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                child: const Text('ENTER'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
