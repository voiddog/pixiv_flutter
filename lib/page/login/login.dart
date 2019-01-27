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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixiv_flutter/auth/auth.dart';
import 'package:pixiv_flutter/bloc/bloc.dart';
import 'package:pixiv_flutter/page/page.dart';

const Color _primaryColor = Color(0xFF2a29e8);

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primaryColor: _primaryColor,
      ),
      child: Scaffold(
        body: Loading(
          child: BlocReceiver<AuthEvent, AuthState>(
            bloc: BlocProvider.of<AuthBloc>(context),
            child: Column(
              children: <Widget>[
                _HeadWelcome(),
                Expanded(
                  child: _LoginForm(),
                )
              ],
            ),
            callback: (context, state) {
              if (state is AuthLoading) {
                Loading.of(context).show();
              } else {
                Loading.of(context).dismiss();
              }
              if (state is Authenticated) {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              } else if (state is Unauthenticated) {
                if (state.message.isNotEmpty == true) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('${state.message}'))
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  /// username or password key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _usernameFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /// 用户名
              _InputText(
                fieldKey: _usernameFieldKey,
                labelText: "EMAIL ADDRESS",
                validator: (String value) {
                  if (value?.isNotEmpty != true) {
                    return "Please Input the email address";
                  }
                },
              ),
              SizedBox(
                height: 24,
              ),
              /// 密码
              _PasswordInput(
                fieldKey: _passwordFieldKey,
                validator: (String value) {
                  if (value?.isNotEmpty != true) {
                    return "Please Input the password";
                  }
                },
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
              /// 按钮部分
              Container(
                width: 150,
                child: RaisedGradientButton(
                  onPressed: () {
                    _submitForm(context);
                  },
                  shadowColor: Color(0x774f64de),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  gradient: LinearGradient(
                      colors: [Color(0xFF657eee), _primaryColor]),
                  child: Text(
                    'Log in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 150,
                child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: _primaryColor),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: _primaryColor, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: Colors.transparent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 提交表格
  void _submitForm(BuildContext context) {
    final FormState state = _formKey.currentState;
    if (!state.validate()) {
      return;
    }
    AuthBloc bloc = BlocProvider.of(context);
    bloc.dispatch(LoginEvent(
        username: _usernameFieldKey.currentState.value,
        password: _passwordFieldKey.currentState.value));
  }
}

class _PasswordInput extends StatefulWidget {
  final String labelText;

  final Key fieldKey;

  final FormFieldValidator<String> validator;

  _PasswordInput({this.fieldKey, this.labelText, this.validator});

  @override
  __PasswordInputState createState() => __PasswordInputState();
}

class __PasswordInputState extends State<_PasswordInput> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return _InputText(
      fieldKey: widget.fieldKey,
      validator: widget.validator,
      labelText: "PASSWORD",
      isPassword: !_isPasswordVisible,
      suffixIcon: IconButton(
          color: _isPasswordVisible ? PixivColors.blue : themeData.hintColor,
          icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          }),
    );
  }
}

/// 输入框
class _InputText extends StatelessWidget {
  final String labelText;

  final bool isPassword;

  final Widget suffixIcon;

  final Key fieldKey;

  final FormFieldValidator<String> validator;

  _InputText(
      {this.fieldKey,
      this.labelText,
      this.isPassword = false,
      this.suffixIcon,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      validator: validator,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18))),
          labelText: this.labelText,
          suffixIcon: this.suffixIcon,
          contentPadding: EdgeInsets.fromLTRB(30, 15, 30, 15)),
      obscureText: isPassword,
    );
  }
}

/// 头部欢迎标题
class _HeadWelcome extends StatefulWidget {
  @override
  _HeadWelcomeState createState() {
    return new _HeadWelcomeState();
  }
}

class _HeadWelcomeState extends State<_HeadWelcome>
    with TickerProviderStateMixin {
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

/// 头部欢迎标题的头部
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
          gradient: LinearGradient(colors: [Color(0xFf4f64de), _primaryColor]),
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
