import 'package:flutter/material.dart';
import 'package:pixiv_flutter/api/api.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _inited = false;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  void _initAuth() async {
    await Auth.instance.init();
    setState(() {
      _inited = true;
    });
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Pixiv',
                style: TextStyle(
                    fontFamily: 'RobotoThin',
                    fontSize: 40,
                    color: Colors.white),
              ),
              SizedBox(
                height: 24,
              ),
              _LoginComponent(),
            ],
          ),
        ),
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
                key: _passwordFieldKey,
                isPassword: true,
                hintText: "Password"),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x659C27B0),
                        offset: Offset(0.0, 5),
                        blurRadius: 10)
                  ],
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.clamp,
                      colors: [Colors.purple[700], Colors.purple[900]])),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: _handleSubmitted,
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
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

  void _handleSubmitted() {
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
    Scaffold.of(formState.context).showSnackBar(SnackBar(
      content: Text(
          "userName: ${_usernameFieldKey.currentState.value}, password: ${_passwordFieldKey.currentState.value}"),
    ));
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
