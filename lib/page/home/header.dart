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
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

class HeadLayout extends StatelessWidget {
  final double contentHeight;
  final double curveHeight;
  final double paddingTop;
  final double animationRatio;
  final VoidCallback onMenuPressed;
  final String title;

  double get totalHeight => contentHeight + curveHeight + paddingTop;

  HeadLayout(
      {@required this.contentHeight,
      @required this.curveHeight,
      @required this.paddingTop,
      this.animationRatio = 0,
      this.onMenuPressed,
      this.title = "Home"})
      : assert(title != null);

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      constraints: BoxConstraints.expand(height: totalHeight),
      child: CustomPaint(
        painter: _HeadPainter(
            curveHeight: curveHeight,
            gradient: LinearGradient(
                colors: [Colors.blue[200], Colors.blue[500], Colors.blue[300]],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0, 0.6, 1])),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: paddingTop,
              left: 0,
              right: 0,
              child: AppBar(
                primary: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: InkResponse(
                  onTap: onMenuPressed,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: SvgPicture.asset(
                      "assets/images/menushort.svg",
                    ),
                  ),
                ),
                title: Text(title),
                actions: <Widget>[
                  Opacity(
                    opacity: animationRatio,
                    child: IconButton(
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed:
                            animationRatio > 0.5 ? _onSearchPressed : null),
                  )
                ],
              ),
            ),
            Positioned(
              left: 35 + 100 * animationRatio,
              right: 35 - 20 * animationRatio,
              bottom: curveHeight + 10,
              child: Opacity(
                  opacity: 1 - animationRatio,
                  child: SearchBar(
                    enable: animationRatio < 0.5,
                  )),
            ),
          ],
        ),
      ),
    );
    if (curveHeight < 2) {
      child = Material(
        child: child,
        color: Colors.transparent,
        elevation: 8,
      );
    }
    return child;
  }

  void _onSearchPressed() {}
}

class SearchBar extends StatefulWidget {
  final double searchHeight;
  final bool enable;

  const SearchBar({Key key, this.searchHeight = 40, this.enable = true})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _searchKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    var defaultBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        borderSide: BorderSide(width: 0, color: Colors.white));
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: widget.searchHeight),
      child: Form(
        key: _formKey,
        child: TextFormField(
          key: _searchKey,
          enabled: widget.enable,
          decoration: InputDecoration(
              border: defaultBorder,
              enabledBorder: defaultBorder,
              disabledBorder: defaultBorder,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 3, color: Colors.blue[200])),
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[400],
                size: 20,
              ),
              hintText: "Search image",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16)),
        ),
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
    final double radio =
        (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return HeadLayout(
      paddingTop: paddingTop,
      contentHeight: contentHeight,
      curveHeight: curveHeight * (1 - radio),
      animationRatio: radio,
    );
  }

  @override
  double get maxExtent =>
      max(contentHeight + paddingTop + curveHeight, minExtent);

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
    paint.isAntiAlias = true;
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
