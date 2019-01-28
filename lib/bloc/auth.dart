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
/// @since 2019-01-28 20:13
///

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:pixiv_flutter/api/api.dart';

/// ======================== 验证状态 ===========================
abstract class AuthState {}

/// 验证未初始化
class AuthUnInit extends AuthState {

  @override
  String toString() => "AuthUnInit";
}

/// 已经登录了
class Authenticated extends AuthState {

  final String accessToken;

  final LoginUser user;

  /// 重新登陆了，或者刷新了 token
  final bool isLogin;

  Authenticated({@required this.accessToken, this.user, this.isLogin = true});

  @override
  String toString() => "Authenticated";
}

/// 未登录
class Unauthenticated extends AuthState {

  /// 前一个状态是登录状态, 改编成了登出
  final bool isLogout;

  /// 如果有错误
  final String message;

  Unauthenticated({this.message, this.isLogout = false});
  @override
  String toString() => "Unauthenticated";
}

/// 请求登录验证中
class AuthLoading extends AuthState {

  static const int STATE_LOGIN = 1;
  static const int STATE_LOGOUT = 2;
  static const int STATE_REFRESH = 3;

  final int state;

  /// auth loading 状态
  AuthLoading(this.state);

  @override
  String toString() => "AuthLoading";
}

/// ======================== 验证事件 ===========================
abstract class AuthEvent {}

/// 初始化事件
class AuthInitEvent extends AuthEvent {

  @override
  String toString() => "InitEvent";
}

/// 登录事件
class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({@required this.username, @required this.password})
      : assert(username != null && password != null);

  @override
  String toString() => "LoginEvent";
}

/// 请求刷新 token 事件
class RefreshTokenEvent extends AuthEvent {

  @override
  String toString() => "RefreshTokenEvent";
}

/// 请求登出事件
class LogoutEvent extends AuthEvent {

  @override
  String toString() => "LogoutEvent";
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({@required this.repository}) : assert(repository != null) {
    repository.init().then((_) {
      dispatch(AuthInitEvent());
    });
  }

  String get authCode => "${repository.tokenType[0].toUpperCase()}${repository.tokenType.substring(1)} ${repository.accessToken}";

  @override
  AuthState get initialState => AuthUnInit();

  @override
  Stream<AuthState> mapEventToState(
      AuthState currentState, AuthEvent event) async* {
    /// 初始化事件
    if (currentState is AuthUnInit) {
      if (event is AuthInitEvent) {
        if (repository.isLogin) {
          yield new Authenticated(
              accessToken: repository.accessToken, user: repository.user);
        } else {
          yield new Unauthenticated();
        }
      }
    } else if (currentState is Unauthenticated) {
      /// 登录事件
      if (event is LoginEvent) {
        yield new AuthLoading(AuthLoading.STATE_LOGIN);
        try {
          LoginResponse response = await repository.login(
              username: event.username, password: event.password);
          yield new Authenticated(
              accessToken: response.accessToken,
              user: response.user,
              isLogin: true);
        } on LoginError catch (e) {
          yield new Unauthenticated(message: e.message);
        }
      }
    } else if (currentState is Authenticated) {
      if (event is RefreshTokenEvent) {
        /// 刷新 token 事件
        yield new AuthLoading(AuthLoading.STATE_REFRESH);
        try {
          LoginResponse response = await repository.refreshToken();
          yield new Authenticated(
              accessToken: response.accessToken,
              user: response.user,
              isLogin: true);
        } on LoginError catch (e) {
          /// 登出事件
          bool isLogout = currentState is Authenticated;
          yield new Unauthenticated(message: e.message, isLogout: isLogout);
        }
      } else if (event is LogoutEvent) {
        yield new AuthLoading(AuthLoading.STATE_LOGOUT);
        await repository.logout();
        bool isLogout = currentState is Authenticated;
        yield new Unauthenticated(isLogout: isLogout);
      }
    }
  }
}
