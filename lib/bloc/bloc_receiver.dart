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
/// @since 2019-01-27 16:35
///
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';

typedef BlocStateChangeCallback<S> = void Function(BuildContext context, S state);

class BlocReceiver<E, S> extends StatefulWidget {
  final Bloc<E, S> bloc;

  final BlocStateChangeCallback<S> callback;

  final Widget child;

  BlocReceiver({Key key, @required this.bloc, this.callback, this.child})
      : assert(bloc != null), super(key: key);

  @override
  _BlocReceiverState<E, S> createState() => _BlocReceiverState<E, S>();
}

class _BlocReceiverState<E, S> extends State<BlocReceiver<E, S>> {
  StreamSubscription<S> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.bloc.state.skip(1).listen((state) {
      widget.callback(context, state);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
