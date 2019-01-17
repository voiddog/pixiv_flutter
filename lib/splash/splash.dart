import 'package:flutter/material.dart';
import 'package:pixiv_flutter/api/api.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _inited = false;
  String _userName;
  String _password;

  final _formKey = GlobalKey<FormState>();

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
        color: Colors.blue,
        child: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            if (_inited || !Auth.instance.isLogin) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Pixiv",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 300,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide:
                                      BorderSide(color: Colors.white)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide:
                                      BorderSide(color: Colors.blue[700])),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: "Please input username",
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "username *"),
                              style: TextStyle(color: Colors.white),
                              onSaved: (String value) {},
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide:
                                      BorderSide(color: Colors.white)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide:
                                      BorderSide(color: Colors.blue[700])),
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: "Please input password",
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "password *"),
                              style: TextStyle(color: Colors.white),
                              onSaved: (String value) {},
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            RaisedButton(
                              color: Colors.blue[700],
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                // start login
                              },
                            ),
                          ],
                        ),
                      ))
                ],
              );
            } else {
              return Text(
                "Pixiv",
                style: TextStyle(color: Colors.white, fontSize: 25),
              );
            }
          }),
        ),
      ),
    );
  }
}
