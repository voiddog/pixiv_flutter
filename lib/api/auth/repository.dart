import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pixiv_flutter/http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
/// @since 2019-01-25 13:05
///
import 'module.dart';
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
/// @since 2019-01-25 13:05
///


class AuthRepository {

  /// 用户信息
  LoginUser get user => _user;

  /// 是否是登录状态
  bool get isLogin => _isLogin;

  /// 获取 access token
  String get accessToken => _accessToken;

  /// token 类型
  String get tokenType => _tokenType;

  /// init share_preference data and check login
  Future<void> init() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _accessToken = sp.getString("access_token");
    _refreshToken = sp.getString("refresh_token");
    _deviceToken = sp.getString("device_token");
    _isLogin = _accessToken != null;
    _tokenType = sp.getString("token_type");
    String userJson = sp.getString("login_user");
    if (userJson != null) {
      _user = LoginUser.fromJson(jsonDecode(userJson));
    }
  }

  /// 请求刷新 token
  Future<LoginResponse> refreshToken() async {
    return _login(type: "refresh_token");
  }

  /// 请求登录
  Future<LoginResponse> login({@required String username, @required password}) async {
    return _login(type: "password", username: username, password: password);
  }

  /// 登出
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _deviceToken = null;
    _tokenType = null;
    _isLogin = null;
    _user = null;
    var sp = await SharedPreferences.getInstance();
    sp.remove("access_token");
    sp.remove("refresh_token");
    sp.remove("device_token");
    sp.remove("token_type");
    sp.remove("login_user");
  }

  /// private area
  static const String _authUrl = "https://oauth.secure.pixiv.net/auth/token";
  static const String _clientId = "MOBrBDS8blbauoSck0ZfDbtuzpyT";
  static const String _clientSecret = "lsACyCD94FhDUtGTXi3QzcFE2uU1hqtDaKeqrdwj";

  String _accessToken;

  String _refreshToken;

  String _deviceToken;

  String _tokenType;

  bool _isLogin = false;

  LoginUser _user;

  void _updateFromLoginResponse(LoginResponse response) async {
    _accessToken = response.accessToken;
    _refreshToken = response.refreshToken;
    _deviceToken = response.deviceToken;
    _tokenType = response.tokenType;
    _isLogin = _accessToken != null;
    Map<String, dynamic> userJsonMap = response.user?.toJson();
    if (userJsonMap != null) {
      _user = LoginUser.fromJson(userJsonMap);
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

  Future<LoginResponse> _login({@required String type, String username, String password}) async {
    try {
      Map<String, String> requestBody = {
        "client_id": _clientId,
        "client_secret": _clientSecret,
        "device_token": "d218b9b2e6adf04249c580a4f0f2d160",
        "include_policy": "true",
        "get_secure_url": "true"
      };
      if (type == "refresh_token") {
        requestBody["grant_type"] = "refresh_token";
        requestBody["refresh_token"] = _refreshToken;
      } else {
        requestBody["grant_type"] = "password";
        requestBody["username"] = username;
        requestBody["password"] = password;
      }
      final response = await PixivHttp.instance.post(_authUrl, body: requestBody);
      LoginResponse loginResponse = LoginResponse.fromJson(json.decode(response.body)["response"]);
      _updateFromLoginResponse(loginResponse);
      return loginResponse;
    } on HttpError catch (e) {
      if (e.code > 0 && e.body?.isNotEmpty == true) {
        // network error
        try {
          Map<String, dynamic> errorResp = jsonDecode(e.body);
          e.message = errorResp['errors']['system']['message'];
        } catch (ignore) {}
      }
      throw LoginError(code: e.code, message: e.message);
    } catch (e) {
      throw LoginError(code: -1, message: "Unknow Login Error");
    }
  }
}