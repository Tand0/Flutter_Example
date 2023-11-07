import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:ui' as ui;
import 'dart:async';
import 'root_data.dart';

class MyImageCanvasAsset extends StatefulWidget {
  const MyImageCanvasAsset({Key? key}) : super(key: key);

  @override
  createState() => _MyImageCanvasAsset();
}

class _MyImageCanvasAsset extends State<MyImageCanvasAsset> {
  Future<ui.Image> _loadImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 512,
      targetHeight: 760,
    );
    var frame = await codec.getNextFrame();
    return frame.image;
  }

  @override
  Widget build(BuildContext context) {
    var x = ModalRoute.of(context)!.settings.arguments;
    String title = "--";
    if (x is RouteData) {
      title = x.title;
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: FutureBuilder<ui.Image>(
            future: _loadImage("images/1girl.png"),
            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Image loading...');
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(
                      child: CustomPaint(
                        painter: MyImagePainter(snapshot.data!),
                        child: const SizedBox(
                          width: 512,
                          height: 760,
                        ),
                      ),
                    );
                  }
              }
            }));
  }

  Widget getImage() {
    return Image.asset('./images/1girl.png');
  }
}

class MyImagePainter extends CustomPainter {
  ui.Image? myImage;
  MyImagePainter(this.myImage);
  @override
  void paint(Canvas canvas, Size size) async {
    if (myImage != null) {
      canvas.drawImage(myImage!, const Offset(0, 0), Paint());
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
