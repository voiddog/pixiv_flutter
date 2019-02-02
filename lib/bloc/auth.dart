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
import 'package:pixiv_flutter/http/http.dart';

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

  /// 从登出状态进入登录
  final bool isLogin;

  /// 从 token 刷新了
  final bool isTokenUpdate;

  Authenticated(
      {@required this.accessToken,
      this.user,
      this.isLogin = false,
      this.isTokenUpdate = false});

  @override
  String toString() => "Authenticated";
}

/// 未登录
class Unauthenticated extends AuthState {
  /// 触发了登出
  final bool isLogout;

  /// 如果有错误
  final String message;

  Unauthenticated({this.message, this.isLogout = false});

  @override
  String toString() => "Unauthenticated";
}

/// token 过期事件
class TokenOverdue extends AuthState {
  @override
  String toString() => "TokenOverdue";
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

class TokenOverdueEvent extends AuthEvent {
  @override
  String toString() => "TokenOverdueEvent";
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const CODE_ERROR_ACCESS_TOKEN = 400;

  final AuthRepository repository;

  AuthBloc({@required this.repository}) : assert(repository != null) {
    PixivHttp.instance.requestInterceptMap["auth"] = _addAuthCode;
    repository.init().then((_) {
      dispatch(AuthInitEvent());
    });
  }

  String get authCode =>
      "${repository.tokenType[0].toUpperCase()}${repository.tokenType.substring(1)} ${repository.accessToken}";

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
              isTokenUpdate: true,
              accessToken: response.accessToken,
              user: response.user);
        } on LoginError catch (e) {
          _onTokenOverdueCheck(e);
        }
      } else if (event is LogoutEvent) {
        yield new AuthLoading(AuthLoading.STATE_LOGOUT);
        await repository.logout();
        bool isLogout = currentState is Authenticated;
        yield new Unauthenticated(isLogout: isLogout);
      } else if (event is TokenOverdueEvent) {
        yield new TokenOverdue();
      }
    } else if (currentState is TokenOverdue) {
      if (event is RefreshTokenEvent) {
        /// 刷新 token 事件
        yield new AuthLoading(AuthLoading.STATE_REFRESH);
        try {
          LoginResponse response = await repository.refreshToken();
          yield new Authenticated(
              accessToken: response.accessToken,
              user: response.user,
              isTokenUpdate: true);
        } catch (ignore) {}
      }
    }
  }

  void _onTokenOverdueCheck(LoginError error) {
    if (error.code == CODE_ERROR_ACCESS_TOKEN) {
      /// token 失效
      dispatch(TokenOverdueEvent());
    }
  }

  String _addAuthCode(String url, Map<String, String> headers, dynamic body) {
    if (currentState is Authenticated || currentState is TokenOverdue) {
      /// add auth code
      if (headers != null) {
        headers["authorization"] = authCode;
      }
    }
    return url;
  }
}
