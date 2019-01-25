import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth.dart';
import 'page/page.dart';
import 'ui/ui.dart';

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
        color: PixivColors.blue,
        theme: ThemeData(
          fontFamily: "Roboto",
        ),
        home: SplashPage(),
      ),
    );
  }
}

