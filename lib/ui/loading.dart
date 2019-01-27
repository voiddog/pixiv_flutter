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
/// @since 2019-01-21 16:40
///
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  static LoadingState of(BuildContext context, {bool nullOk = true}) {
    final LoadingState state =
        context.ancestorStateOfType(TypeMatcher<LoadingState>());
    assert(() {
      if (state == null && !nullOk) {
        throw FlutterError('No loading state found in the build tree');
      }
      return true;
    }());
    return state;
  }

  /// default overlay function
  static Widget createOverlay(BuildContext context) {
    return Container(
      color: Color(0x55000000),
      child: Center(
        child: Container(
          width: 55,
          height: 55,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(6.0)),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  final bool initShowLoading;

  final Widget child;

  final WidgetBuilder overlayBuilder;

  final Duration animationDuration;

  Loading(
      {Key key,
      this.initShowLoading = false,
      this.child,
      this.animationDuration = const Duration(milliseconds: 200),
      this.overlayBuilder = createOverlay})
      : assert(overlayBuilder != null),
        assert(initShowLoading != null),
        assert(animationDuration != null),
        super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  void show() {
    setState(() {
      _showLoading = true;
      _controller.forward();
    });
  }

  void dismiss() {
    setState(() {
      _showLoading = false;
      _controller.reverse();
    });
  }

  bool get isLoading => _showLoading;

  AnimationController _controller;
  Animation<double> _animation;
  bool _showLoading = false;

  @override
  void initState() {
    _showLoading = widget.initShowLoading;
    _controller = AnimationController(
        vsync: this,
        duration: widget.animationDuration,
        value: _showLoading ? 1 : 0);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        var children = [child];
        if (_controller.isAnimating || _controller.isCompleted) {
          // show loading
          final Widget loading = widget.overlayBuilder(context);
          children.add(AbsorbPointer(
            child: Opacity(
              opacity: _animation.value,
              child: loading,
            ),
          ));
        }
        return Stack(
          children: children,
        );
      },
      child: widget.child,
    );
  }
}
