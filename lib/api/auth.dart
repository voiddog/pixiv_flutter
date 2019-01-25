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
/// @since 2019-01-22 16:12
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'module.dart';

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

  Map<String, String> getRequestHeader({bool isAuth = true, bool authThrowIfNotLogin = true, bool addRefer = false}) {
    if (isAuth && !isLogin && authThrowIfNotLogin) {
      throw AuthError();
    }
    Map<String, String> ret = {
      "User-Agent": "PixivAndroidApp/5.0.121 (Android 6.0.1; MI 4LTE)",
      "Accept-Language": "zh_CN",
      "App-OS": "android",
      "App-OS-Version": "6.0.1",
      "App-Version": "5.0.121",
    };
    if (isAuth) {
      ret["Authorization"] = "$_tokenType $_accessToken";
    }
    if (addRefer) {
      ret["Referer"] = "https://www.pixiv.net/";
    }
    return ret;
  }

  /// 请求刷新 token
  Future<LoginResponse> refreshToken() async {
    if (!isLogin) {
      throw AuthError();
    }
    final response = await _post(_authUrl,
        headers: getRequestHeader(isAuth: true),
        body: {
          "client_id": _clientId,
          "client_secret": _clientSecret,
          "grant_type": "refresh_token",
          "device_token": "d218b9b2e6adf04249c580a4f0f2d160",
          "refresh_token": _refreshToken,
          "include_policy": "true",
          "get_secure_url": "true"
        });
    LoginResponse loginResponse = LoginResponse.fromJson(json.decode(response.body)["reponse"]);
    _updateFromLoginResponse(loginResponse);
    return loginResponse;
  }

  Future<LoginResponse> login({@required String username, @required password}) async {
    try {
      final response = await _post(_authUrl,
          headers: getRequestHeader(isAuth: false),
          body: {
            "client_id": _clientId,
            "client_secret": _clientSecret,
            "grant_type": "password",
            "username": username,
            "password": password,
            "device_token": "d218b9b2e6adf04249c580a4f0f2d160",
            "include_policy": "true",
            "get_secure_url": "true"
          });
      LoginResponse loginResponse = LoginResponse.fromJson(json.decode(response.body)["response"]);
      _updateFromLoginResponse(loginResponse);
      return loginResponse;
    } on NetworkError catch (e) {
      if (e.code > 0 && e.reason?.isNotEmpty == true) {
        // network error
        try {
          Map<String, dynamic> errorResp = jsonDecode(e.reason);
          e.message = errorResp['errors']['system']['message'];
        } catch (ignore) {}
      }
      throw e;
    }
  }
  
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

Future<http.Response> _post(url, {Map<String, String> headers, body, Encoding encoding}) async {
  try {
    var response = await http.post(
        url, headers: headers, body: body, encoding: encoding);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw NetworkError()
        ..code = response.statusCode
        ..message = 'network error'
        ..reason = response.body;
    }
  } catch (e, stackTrace) {
    print('$e');
    print('$stackTrace');
    String message;
    if (e is NetworkError) {
      throw e;
    } else if (e is http.ClientException)  {
      message = e.message;
    } else if (e is SocketException) {
      if (e.message?.isNotEmpty == true) {
        message = e.message;
      } else {
        message = '${e.osError}';
      }
    }
    if (message?.isNotEmpty == false) {
      message = 'Unknown error';
    }
    // Anything else that is an exception
    throw NetworkError()
      ..code = -1
      ..message = message
      ..reason = '$e';
  }
}
