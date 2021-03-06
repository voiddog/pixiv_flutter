import 'package:flutter/material.dart';
import 'package:pixiv_flutter/bloc/bloc.dart';

import 'api/api.dart';
import 'page/page.dart';

void main() => runApp(PixivApp());

class PixivApp extends StatefulWidget {
  @override
  _PixivAppState createState() => _PixivAppState();
}

class _PixivAppState extends State<PixivApp> {
  /// 登录组件
  final AuthBloc _authBloc = AuthBloc(repository: AuthRepository());

  @override
  void dispose() {
    super.dispose();
    _authBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authBloc,
      child: MaterialApp (
        theme: ThemeData(
          fontFamily: "Roboto",
        ),
        home: SplashPage(),
      ),
    );
  }
}

