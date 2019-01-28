///
/// ┏┛ ┻━━━━━┛ ┻┓
/// ┃　　　　　　 ┃
/// ┃　　　━　　　┃
/// ┃　┳┛　  ┗┳　┃
/// ┃　　　　　　 ┃
/// ┃　　　┻　　　┃
/// ┃　　　　　　 ┃
/// ┗━┓　　　┏━━━┛
/// * ┃　　　┃   神兽保佑
/// * ┃　　　┃   代码无BUG！
/// * ┃　　　┗━━━━━━━━━┓
/// * ┃　　　　　　　    ┣┓
/// * ┃　　　　         ┏┛
/// * ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
/// * * ┃ ┫ ┫   ┃ ┫ ┫
/// * * ┗━┻━┛   ┗━┻━┛
/// @author qigengxin
/// @since 2019-01-29 00:51
///
import 'package:flutter/material.dart';
import 'dart:math';

class HeadLayout extends StatelessWidget {

  final double contentHeight;
  final double curveHeight;
  final double paddingTop;
  final double animationRatio;

  double get totalHeight => contentHeight + curveHeight + paddingTop;

  HeadLayout(
      {@required this.contentHeight,
      @required this.curveHeight,
      @required this.paddingTop,
      this.animationRatio = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: totalHeight),
      child: CustomPaint(
        painter: _HeadPainter(
            curveHeight: curveHeight,
            gradient: LinearGradient(
                colors: [Colors.blue[400], Colors.blue[700], Colors.blue[600]],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0, 0.6, 1])),
      ),
    );
  }
}

class HeadDelegate extends SliverPersistentHeaderDelegate {

  final double curveHeight;
  final double contentHeight;
  final double closeHeight;
  final double paddingTop;

  HeadDelegate(
      {this.contentHeight,
        this.closeHeight = kToolbarHeight,
        this.paddingTop,
        this.curveHeight = 50});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double radio = 1.0 - (shrinkOffset / (maxExtent - minExtent)).clamp(0, 1);

    return HeadLayout(
      paddingTop: paddingTop,
      contentHeight: contentHeight,
      curveHeight: curveHeight*radio,
      animationRatio: radio,
    );
  }

  @override
  double get maxExtent => max(contentHeight+paddingTop+curveHeight, minExtent);

  @override
  double get minExtent => closeHeight + paddingTop;

  @override
  bool shouldRebuild(HeadDelegate oldDelegate) {
    return contentHeight != oldDelegate.contentHeight ||
        curveHeight != oldDelegate.curveHeight ||
        paddingTop != oldDelegate.paddingTop ||
        closeHeight != oldDelegate.closeHeight;
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
