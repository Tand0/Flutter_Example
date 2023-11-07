import 'package:flutter/material.dart';
import 'my_image.dart';

class MyImageWeb extends MyImage {
  const MyImageWeb({Key? key}) : super(key: key);

  @override
  Widget getImage() {
    return Image.network(
        'https://raw.githubusercontent.com/Tand0/NovelAI_input_support_android/main/src/main/res/raw/solo.png');
  }
}
