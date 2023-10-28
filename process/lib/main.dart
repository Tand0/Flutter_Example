import 'dart:async';
import 'package:process_run/shell.dart';

void main() {
  MyProcess myProcess = MyProcess();
  //
  String command = "start chrome http://192.168.1.3:3001/";
  myProcess.executeProcess(command);
}

class MyProcess {
  Future<void> executeProcess(String command) async {
    var shell = Shell();
    await shell.run(command);
  }
}
