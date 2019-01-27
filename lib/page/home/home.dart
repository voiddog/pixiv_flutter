import 'package:flutter/material.dart';
import 'dart:math';
import 'package:pixiv_flutter/ui/ui.dart';

class HomePage extends StatefulWidget {
  HomePage() : super(key: GlobalKey(debugLabel: "[home]"));

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5fafe),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: _HeadDelegate(
              paddingTop: MediaQuery.of(context).padding.top,
              expandHeight: 300,
            ),
          )
        ],
      ),
    );
  }
}

class _HeadPainter extends CustomPainter {
  final Gradient gradient;
  final double curveHeight;

  _HeadPainter({this.gradient, this.curveHeight = 0})
      : assert(gradient != null);

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint()..shader = gradient.createShader(rect);
    double distance = size.width / 3;
    canvas.drawPath(
        Path()
          ..moveTo(rect.left, rect.top)
          ..lineTo(rect.right, rect.top)
          ..lineTo(rect.right, rect.bottom - curveHeight)
          ..cubicTo(rect.right - distance, rect.bottom, rect.left + distance,
              rect.bottom, rect.left, rect.bottom - curveHeight)
          ..lineTo(rect.left, rect.top),
        paint);
  }

  @override
  bool shouldRepaint(_HeadPainter oldDelegate) {
    return gradient != oldDelegate.gradient ||
        curveHeight != oldDelegate.curveHeight;
  }
}

class _HeadDelegate extends SliverPersistentHeaderDelegate {
  final double curveHeight;
  final double expandHeight;
  final double closeHeight;
  final double paddingTop;

  _HeadDelegate(
      {this.expandHeight,
      this.closeHeight = kToolbarHeight,
      this.paddingTop,
      this.curveHeight = 50});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width;
    final double visibleMainHeight = maxExtent - shrinkOffset - paddingTop;
    final double radio = (visibleMainHeight / expandHeight).clamp(0, 1);

    return CustomPaint(
      painter: _HeadPainter(
          curveHeight: curveHeight * radio,
          gradient: LinearGradient(
              colors: [Colors.blue[400], Colors.blue[700], Colors.blue[600]],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0, 0.6, 1])),
      child: Center(),
    );
  }

  @override
  double get maxExtent => max(expandHeight, minExtent);

  @override
  double get minExtent => closeHeight + paddingTop;

  @override
  bool shouldRebuild(_HeadDelegate oldDelegate) {
    return expandHeight != oldDelegate.expandHeight ||
        closeHeight != oldDelegate.closeHeight;
  }
}
