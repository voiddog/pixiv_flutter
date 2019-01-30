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
/// @since 2019-01-25 12:20
///
export 'module.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'module.dart';

class Http {

  static Map<String, String> _defaultRequestHeader = {
    "User-Agent": "PixivAndroidApp/5.0.121 (Android 6.0.1; MI 4LTE)",
    "Accept-Language": "zh_CN",
    "App-OS": "android",
    "App-OS-Version": "6.0.1",
    "App-Version": "5.0.121",
  };

  static Future<http.Response> get(url, {Map<String, String> headers}) async {
    Map<String, String> finalHeaders = Map.from(_defaultRequestHeader);
    if (headers != null) {
      finalHeaders.addAll(headers);
    }
    try {
      _logRequest(url, finalHeaders, null);
      http.Response response = await http.get(url, headers: headers);
      _logReponse(url, response.body);
      if (response.statusCode == 200) {
        return response;
      }
      throw HttpError(
          code: response.statusCode,
          body: response.body
      );
    } on HttpError catch (e) {
      throw e;
    } catch (e) {
      /// get error message
      String message;
      if (e is http.ClientException) {
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
      throw HttpError(
          code: -1,
          errorMessage: ErrorMessage()..message=message,
          originException: e
      );
    }
  }

  /// 发送 post 请求
  /// [headers] 请求头，默认会填上 [_defaultRequestHeader]，如果不为空，则会覆盖默认里面的 header
  /// [body] 请求数据体
  /// [encoding] 请求编码，默认 UTF-8
  static Future<http.Response> post(url, {Map<String, String> headers, dynamic body,
    Encoding encoding}) async {
    Map<String, String> finalHeaders = Map.from(_defaultRequestHeader);
    if (headers != null) {
      finalHeaders.addAll(headers);
    }
    try {
      _logRequest(url, finalHeaders, body);
      http.Response response = await http.post(url, headers: finalHeaders,
          body: body, encoding: encoding);
      _logReponse(url, response.body);
      if (response.statusCode == 200) {
        return response;
      }
      throw HttpError(
        code: response.statusCode,
        body: response.body
      );
    } on HttpError catch (e) {
      throw e;
    } catch (e) {
      /// get error message
      String message;
      if (e is http.ClientException) {
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
      throw HttpError(
        code: -1,
        errorMessage: ErrorMessage()..message=message,
        originException: e
      );
    }
  }

  static void _logRequest(String url, Map<String, String> header, dynamic body) {
    print('start request to url: $url');
    print('header: $header');
    print('body: $body');
  }

  static void _logReponse(String url, String body) {
    print('on response get at: $url');
    print('response: $body');
  }
}