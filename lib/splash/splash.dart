import 'package:flutter/material.dart';
import 'package:pixiv_flutter/api/api.dart';
import 'package:pixiv_flutter/ui/raised_gradient_button.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    super.initState();
    _initAuth();
  }

  void _initAuth() async {
    int startTime = DateTime.now().millisecond;
    await Auth.instance.init();
    if (!mounted) {
      return;
    }
    if (Auth.instance.isLogin) {
      /// jump to home
    } else {
      int waitTime = DateTime.now().millisecond - startTime;
      waitTime = 2000 - waitTime;
      if (waitTime > 0) {
        await Future.delayed(Duration(milliseconds: waitTime), (){});
      }
      if (mounted) {
        _controller.forward();
      }
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
          child: _SplashComponent(animation: _animation,),
        ),
      ),
    );
  }
}

class _SplashComponent extends AnimatedWidget {

  _SplashComponent({Key key, Animation<double> animation})
      : super (key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    double value = 1 - (listenable as Animation<double>).value;
    return
      Transform.translate(
        offset: Offset(0, 100 * value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Transform.scale(
              scale: value + 1,
              child: Text(
                'Pixiv',
                style: TextStyle(
                    fontFamily: 'RobotoThin',
                    fontSize: 40,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Opacity(opacity: 1 - value, child: _LoginComponent()),
          ],
        ),
      );
  }
}


class _LoginComponent extends StatefulWidget {
  @override
  __LoginComponentState createState() => __LoginComponentState();
}

class __LoginComponentState extends State<_LoginComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _usernameFieldKey =
  GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _createInputForm(
              key: _usernameFieldKey,
              hintText: "UserName",),
            SizedBox(
              height: 30,
            ),
            _createInputForm(
                key: _passwordFieldKey, isPassword: true, hintText: "Password"),
            SizedBox(
              height: 30,
            ),
            Container(
              constraints: BoxConstraints.expand(height: 50),
              child: RaisedGradientButton(
                shadowColor: Color(0xFF9C27B0),
                elevation: 8.0,
                highlightElevation: 12.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                onPressed: _handleSubmitted,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    tileMode: TileMode.clamp,
                    colors: [Colors.purple[700], Colors.purple[900]]),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isLogining = false;

  void _handleSubmitted() {
    /// if is request login, just return
    if (_isLogining) {
      return;
    }
    final FormState formState = _formKey.currentState;
    String usrename = _usernameFieldKey.currentState.value;
    String password = _passwordFieldKey.currentState.value;
    if (usrename.isEmpty) {
      Scaffold.of(formState.context).showSnackBar(SnackBar(
        content: Text('Username is required.'),
      ));
      return;
    }
    if (password.isEmpty) {
      Scaffold.of(formState.context).showSnackBar(SnackBar(
        content: Text('Password is required.'),
      ));
      return;
    }

    /// TODO start login
  }

  Widget _createInputForm(
      {Key key,
        bool isPassword = false,
        String hintText,
        FormFieldSetter<String> onSaved}) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(6.0),
      child: TextFormField(
        key: key,
        obscureText: isPassword,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(width: 0, color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: BorderSide(color: Colors.blue[200], width: 3)),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 12)),
        onSaved: onSaved,
      ),
    );
  }
}
