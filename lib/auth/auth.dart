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
/// @since 2019-01-25 12:47
///
export 'repository.dart';
export 'module.dart';

import 'package:bloc/bloc.dart';
import 'repository.dart';
import 'module.dart';
import 'package:flutter/foundation.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  
  final AuthRepository repository;
  
  AuthBloc({@required this.repository}) : assert(repository != null) {
    repository.init().then((_) {
      dispatch(AuthInitEvent());
    });
  }

  @override
  AuthState get initialState => AuthUnInit();

  @override
  Stream<AuthState> mapEventToState(AuthState currentState, AuthEvent event) async* {
    /// 初始化完毕事件
    if (event is AuthInitEvent) {
      if (repository.isLogin) {
        yield new Authenticated(accessToken: repository.accessToken, user: repository.user);
      } else {
        yield new Unauthenticated();
      }
    }
    /// 登录事件
    if (event is LoginEvent) {
      yield new AuthLoading(AuthLoading.STATE_LOGIN);
      try {
        LoginResponse response = await repository.login(username: event.username, password: event.password);
        yield new Authenticated(accessToken: response.accessToken, user: response.user);
      } on LoginError catch (e) {
        yield new Unauthenticated(message: e.message);
      }
    }
    /// 刷新 token 事件
    if (event is RefreshTokenEvent) {
      yield new AuthLoading(AuthLoading.STATE_REFRESH);
      try {
        LoginResponse response = await repository.refreshToken();
        yield new Authenticated(accessToken: response.accessToken, user: response.user);
      } on LoginError catch (e) {
        yield new Unauthenticated(message: e.message);
      }
    }
    /// 登出事件
    if (event is LogoutEvent) {
      yield new AuthLoading(AuthLoading.STATE_LOGOUT);
      await repository.logout();
      yield new Unauthenticated();
    }
  }
}
