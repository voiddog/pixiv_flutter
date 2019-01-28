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

/// ================ 错误 ===================
class LoginError implements Exception {
  int code;
  String message;

  LoginError({@required this.code, @required this.message}) {
    message = message ?? "Login Empty Error";
  }
}