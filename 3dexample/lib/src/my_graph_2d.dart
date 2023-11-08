import 'package:flutter/material.dart';
import 'my_graph_caller.dart';

class MyGraph2D extends StatelessWidget {
  const MyGraph2D({Key? key}) : super(key: key);

  static const String callName = "/Graph2D";
  static const String _title = "2D sample";

  @override
  Widget build(BuildContext context) {
    var x = ModalRoute.of(context)!.settings.arguments;
    Widget me;
    String title = _title;
    if (x is MyGraphCaller2D) {
      me = CustomPaint(painter: _MyCustomPainter(x));
      title = x.title;
    } else {
      me = Text('caller not found. x=${x.toString()}');
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: SizedBox(
            width: double.infinity, height: double.infinity, child: me));
  }
}

class _MyCustomPainter extends CustomPainter {
  final MyGraphCaller2D myGraphCaller;
  _MyCustomPainter(this.myGraphCaller);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  double getBoxXToRealX(double boxX) {
    return realXMin +
        (realXMax - realXMin) * (boxX - boxXMin) / (boxXMax - boxXMin);
  }

  double getRealXToBoxX(double realX) {
    return boxXMin +
        (boxXMax - boxXMin) * (realX - realXMin) / (realXMax - realXMin);
  }

  double getRealYToBoxY(double realY) {
    return boxYMax -
        (boxYMax - boxYMin) * (realY - realYMin) / (realYMax - realYMin);
  }

  double boxXMin = 0;
  double boxXMax = 100;
  double boxYMin = 0;
  double boxYMax = 100;
  double realXMin = 0.0;
  double realXMax = 1.0;
  double realYMin = 0.0;
  double realYMax = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    const sampleTextStyle = TextStyle(color: Colors.black, fontSize: 12);
    final text = TextPainter(
      textDirection: TextDirection.ltr,
      text: const TextSpan(
        style: sampleTextStyle,
        text: 'musure text len',
      ),
    )..layout();

    //
    boxXMin = text.size.width;
    boxXMax = size.width - (text.size.width / 2);
    boxYMin = text.size.height * 3;
    boxYMax = size.height - (text.size.height * 5);
    realXMin = myGraphCaller.xMin;
    realXMax = myGraphCaller.xMax;
    realYMin = myGraphCaller.yMin;
    realYMax = myGraphCaller.yMax;

    final paintX = Paint();
    paintX.color = Colors.black12;
    paintX.strokeWidth = 1.0;
    //
    for (double realX = realXMin;
        realX <= realXMax;
        realX += (realXMax - realXMin) / 10) {
      double boxX = getRealXToBoxX(realX);
      canvas.drawLine(Offset(boxX, boxYMin), Offset(boxX, boxYMax), paintX);
    }
    for (double realY = realYMin;
        realY <= realYMax;
        realY += (realYMax - realYMin) / 10) {
      double boxY = getRealYToBoxY(realY);
      canvas.drawLine(Offset(boxXMin, boxY), Offset(boxXMax, boxY), paintX);
    }
    //
    paintX.color = Colors.black38;
    for (double realX = realXMin;
        realX <= realXMax;
        realX += (realXMax - realXMin) / 2) {
      TextPainter text = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          style: sampleTextStyle,
          text: realX.toString(),
        ),
      )..layout();
      double boxX = getRealXToBoxX(realX);
      double textX = boxX - (text.size.width / 2);
      double textY = boxYMax + 5;
      text.paint(canvas, Offset(textX, textY));
      canvas.drawLine(Offset(boxX, boxYMin), Offset(boxX, boxYMax), paintX);
    }
    //
    for (double realY = realYMin;
        realY <= realYMax;
        realY += (realYMax - realYMin) / 2) {
      TextPainter text = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          style: sampleTextStyle,
          text: realY.toString(),
        ),
      )..layout();
      double boxY = getRealYToBoxY(realY);
      double textX = boxXMin - text.size.width - 5;
      double textY = boxY - (text.size.height / 2);
      var offset = Offset(textX, textY);
      text.paint(canvas, offset);
      canvas.drawLine(Offset(boxXMin, boxY), Offset(boxXMax, boxY), paintX);
    }
    //
    // default setting
    List<Color> colorList = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.cyan,
      Colors.black,
      Colors.orange
    ];
    paintX.strokeWidth = 1.0;
    paintX.style = PaintingStyle.stroke;
    //
    List<List<double>> realYList = [];
    for (int boxX = boxXMin.toInt(); boxX < boxXMax; boxX++) {
      double realX = getBoxXToRealX(boxX.toDouble());
      List<double> oneCall = myGraphCaller.call(realX);
      realYList.add(oneCall);
    }
    for (int i = 0; i < realYList[0].length; i++) {
      paintX.color = colorList[i % colorList.length];
      double boxY = getRealYToBoxY(realYList[0][i]);
      Offset oe = Offset(boxXMin, boxY);
      for (int j = 1; j < realYList.length; j++) {
        Offset os = oe;
        boxY = getRealYToBoxY(realYList[j][i]);
        oe = Offset(boxXMin + j, boxY);
        canvas.drawLine(os, oe, paintX);
      }
    }
  }
}
