import 'package:flutter/material.dart';
import 'my_image.dart';

class MyImageAsset extends MyImage {
  const MyImageAsset({Key? key}) : super(key: key);

  @override
  Widget getImage() {
    return Image.asset('images/1girl.png');
  }
}
