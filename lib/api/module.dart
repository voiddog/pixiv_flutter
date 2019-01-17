import 'package:shared_preferences/shared_preferences.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'module.g.dart';

@JsonSerializable()
class User {

  String id;

  String name;

  String account;

  @JsonKey(name: "mail_address")
  String mailAddress;

  @JsonKey(name: "is_premium")
  bool isPremium;

  @JsonKey(name: "profile_image_urls")
  Map<String, String> profileImgUrls;

  String comment;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class LoginResponse {

  @JsonKey(name: "access_token")
  String accessToken;

  @JsonKey(name: "token_type")
  String tokenType;

  @JsonKey(name: "refresh_token")
  String refreshToken;

  @JsonKey(name: "devoce_token")
  String deviceToken;

  User user;

  LoginResponse();

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginReponseFromJson(json);
}

/// 登录验证
class Auth {

  /// singleton
  static Auth get instance {
    if (_instance == null) {
      _instance = Auth._internal();
    }
    return _instance;
  }
  static Auth _instance;

  /// init share_prefernece data and check login
  Future<void> init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _accessToken = sp.getString("access_token");
    _refreshToken = sp.getString("refresh_token");
    _deviceToken = sp.getString("device_token");
    _isLogin = _accessToken != null;
    _tokenType = sp.getString("token_type");
    String userJson = sp.getString("login_user");
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
    }
  }

  User get user => _user;

  bool get isLogin => _isLogin;

  Future<LoginResponse> login({@required String username, @required password}) async {
    final response = await http.post(_authUrl,
      headers: {
        "User-Agent": "PixivAndroidApp/5.0.121 (Android 6.0.1; MI 4LTE)",
        "Accept-Language": "zh_CN",
        "App-OS": "android",
        "App-OS-Version": "6.0.1",
        "App-Version": "5.0.121"
      },
      body: {
        "client_id": _clientId,
        "client_secret": _clientSecret,
        "grant_type": "password",
        "username": username,
        "password": password,
        "device_token": "device_token",
        "include_policy": true,
        "get_secure_url": true
      });

      if (response.statusCode == 200) {
        LoginResponse loginResponse = LoginResponse.fromJson(json.decode(response.body));
        _updateFromLoginResponse(loginResponse);
        return loginResponse;
      } else {
        throw Exception("Failed to login, error code: ${response.statusCode}");
      }
  }

  /// private area
  static const String _authUrl = "https://oauth.secure.pixiv.net/auth/token";
  static const String _clientId = "BVO2E8vAAikgUBW8FYpi6amXOjQj";
  static const String _clientSecret = "LI1WsFUDrrquaINOdarrJclCrkTtc3eojCOswlog";

  String _accessToken;
  
  String _refreshToken;

  String _deviceToken;

  String _tokenType;

  bool _isLogin;

  User _user;

  Auth._internal();

  void _updateFromLoginResponse(LoginResponse response) async {
    _accessToken = response.accessToken;
    _refreshToken = response.refreshToken;
    _deviceToken = response.deviceToken;
    _tokenType = response.tokenType;
    _isLogin = _accessToken != null;
    Map<String, dynamic> userJsonMap = response.user?.toJson();
    if (userJsonMap != null) {
      _user = User.fromJson(userJsonMap);
    } else {
      _user = null;
    }
    var sp = await SharedPreferences.getInstance();
    sp.setString("access_token", _accessToken);
    sp.setString("refresh_token", _refreshToken);
    sp.setString("device_token", _deviceToken);
    sp.setString("token_type", _tokenType);
    if (userJsonMap != null) {
      sp.setString("login_user", jsonEncode(userJsonMap));
    } else {
      sp.remove("login_user");
    }
  }
}