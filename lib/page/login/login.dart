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
/// @since 2019-01-25 14:08
///
import 'package:flutter/material.dart';
import 'package:pixiv_flutter/ui/ui.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Loading(
        child: Column(
          children: <Widget>[
            _HeadWelcome(),
            Expanded(
              child: Form(
                child: Center(
                  child: Container(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              labelText: "EMAIL ADDRESS",
                              contentPadding:
                                  EdgeInsets.fromLTRB(30, 15, 30, 15)),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18))),
                              labelText: "PASSWORD",
                              contentPadding:
                                  EdgeInsets.fromLTRB(30, 15, 30, 15)),
                          obscureText: true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                                onPressed: () {},
                                child: Text(
                                  'Forget password?',
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          width: 150,
                          child: RaisedGradientButton(
                            onPressed: () {},
                            shadowColor: Color(0x774f64de),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            gradient: LinearGradient(
                                colors: [Color(0xFF657eee), Color(0xFF2a29e8)]),
                            child: Text('Log in', style: TextStyle(color: Colors.white),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HeadWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    double bigBallSize = mediaQueryData.size.width * 3 / 4;
    double smallBallSize = bigBallSize / 4;

    return Container(
      height: bigBallSize,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: -0.15 * bigBallSize,
            top: -0.15 * bigBallSize,
            child: _Ball(
              constraints: BoxConstraints.tightFor(
                  width: bigBallSize, height: bigBallSize),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Welcome Back,',
                      style: TextStyle(
                          color: Colors.white, fontSize: bigBallSize / 15),
                    ),
                    Text(
                      'Log In!',
                      style: TextStyle(
                          color: Colors.white, fontSize: bigBallSize / 6.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: _Ball(
              constraints: BoxConstraints.tight(Size.square(smallBallSize)),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2a29e8),
                  boxShadow: [
                    BoxShadow(color: PixivColors.blue, blurRadius: 20)
                  ]),
            ),
          )
        ],
      ),
    );
  }
}

class _Ball extends StatelessWidget {
  final BoxConstraints constraints;

  final Decoration decoration;

  final Widget child;

  const _Ball(
      {Key key,
      this.child,
      this.constraints,
      this.decoration = const BoxDecoration(
          shape: BoxShape.circle,
          gradient:
              LinearGradient(colors: [Color(0xFf4f64de), Color(0xFF2a29e8)]),
          boxShadow: [BoxShadow(color: PixivColors.blue, blurRadius: 20)])})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      decoration: decoration,
      child: child,
    );
  }
}
