import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
part 'module.g.dart';

/// 登录用户数据
@JsonSerializable()
class LoginUser {
  String id;

  String name;

  String account;

  String mailAddress;

  bool isPremium;

  Map<String, String> profileImgUrls;

  String comment;

  bool isMailAuthorized;

  LoginUser();

  factory LoginUser.fromJson(Map<String, dynamic> json) => _$LoginUserFromJson(json);

  Map<String, dynamic> toJson() => _$LoginUserToJson(this);
}

@JsonSerializable()
class LoginResponse {

  String accessToken;

  String tokenType;

  String refreshToken;

  String deviceToken;

  LoginUser user;

  LoginResponse();

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

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

  Authenticated({@required this.accessToken, this.user});

  @override
  String toString() => "Authenticated";
}

/// 未登录
class Unauthenticated extends AuthState {
  /// 如果有错误
  final String message;

  Unauthenticated({this.message});
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

/// ================ 错误 ===================
class LoginError implements Exception {
  int code;
  String message;

  LoginError({@required this.code, @required this.message}) {
    message = message ?? "Login Empty Error";
  }
}