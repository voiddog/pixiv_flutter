import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixiv_flutter/api/api.dart';
import 'package:pixiv_flutter/page/page.dart';

class SplashPage extends StatefulWidget {
  SplashPage() : super();

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  /// pixiv 的图标至少停留 2 s
  static const int _stayTime = 2000;
  int _startInitTime;

  /// 登录 stats
  StreamSubscription<AuthState> _subscription;

  @override
  void initState() {
    super.initState();
    _startInitTime = DateTime.now().millisecondsSinceEpoch;
    _initAuth();
  }

  void _initAuth() async {
    if (_subscription == null) {
      AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
      _subscription = bloc.state.skip(1).listen((state) {
        if (state is Authenticated) {
          _jumpToHome(context);
        } else if (state is Unauthenticated) {
          _jumpToLogin(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                tileMode: TileMode.clamp,
                colors: [Colors.blue[300], Colors.blue[900]])),
        child: Center(
            child: InkWell(
          onTap: () {
            _jumpToLogin(context);
          },
          child: Text(
            'Pixiv',
            style: TextStyle(
              fontFamily: 'RobotoThin',
              fontSize: 80,
              color: Colors.white,
            ),
          ),
        )),
      ),
    );
  }

  void _jumpToLogin(BuildContext context) async {
    _subscription?.cancel();
    _subscription = null;
    int duration = DateTime.now().millisecondsSinceEpoch - _startInitTime;
    duration = _stayTime - duration;
    if (duration > 0) {
      await Future.delayed(Duration(milliseconds: duration));
    }
    if (mounted) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    }
  }

  void _jumpToHome(BuildContext context) async {
    _subscription?.cancel();
    _subscription = null;
    int duration = DateTime.now().millisecondsSinceEpoch - _startInitTime;
    duration = _stayTime - duration;
    if (duration > 0) {
      await Future.delayed(Duration(milliseconds: duration));
    }
    if (mounted) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    }
  }
}
