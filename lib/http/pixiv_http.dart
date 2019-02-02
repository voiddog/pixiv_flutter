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
/// @since 2019-02-01 11:50
///
import 'module.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

typedef ErrorTransform = HttpError Function(HttpError error);

typedef RequestIntercept = String Function(String url, Map<String, String> headers, dynamic body);

class PixivHttp {
  static Map<String, String> _defaultRequestHeader = {
    "User-Agent": "PixivAndroidApp/5.0.121 (Android 6.0.1; MI 4LTE)",
    "Accept-Language": "zh_CN",
    "App-OS": "android",
    "App-OS-Version": "6.0.1",
    "App-Version": "5.0.121",
  };

  static PixivHttp get instance => _instance;

  static PixivHttp _instance = PixivHttp._();

  /// 默认的错误处理
  static HttpError _defaultErrorTransform(HttpError error) {
    try {
      if (error.body?.isNotEmpty == true) {
        ErrorMessage errorMessage =
            ErrorMessage.fromJson(jsonDecode(error.body)["error"]);
        if (errorMessage.message?.isNotEmpty == true) {
          error.message = errorMessage.message;
        } else if (errorMessage.userMessage?.isNotEmpty == true) {
          error.message = errorMessage.userMessage;
        }
      }
    } catch (ignore) {}
    return error;
  }

  /// 错误转换表
  Map<String, ErrorTransform> errorTransformMap = {};
  /// 请求拦截表
  Map<String, RequestIntercept> requestInterceptMap = {};

  /// get 请求
  /// [url] get 请求的地址
  /// [headers] get 请求头
  /// [errorTransform] 请求错误变换逻辑，可以用来解析错误内容
  Future<http.Response> get(String url,
      {Map<String, String> headers,
      ErrorTransform errorTransform = _defaultErrorTransform}) async {
    Map<String, String> finalHeaders = Map.from(_defaultRequestHeader);
    if (headers != null) {
      finalHeaders.addAll(headers);
    }
    try {
      url = _processRequest(url, finalHeaders, null);
      http.Response response = await http.get(url, headers: finalHeaders);
      if (response.statusCode == 200) {
        /// request success
        return response;
      }
      var error = HttpError(
          code: response.statusCode,
          message: "Http code: ${response.statusCode}",
          body: response.body);
      error.originException = error;
      throw error;
    } catch (e) {
      throw _onCatchError(e, errorTransform);
    }
  }

  /// 发送 post 请求
  /// [headers] 请求头，默认会填上 [_defaultRequestHeader]，如果不为空，则会覆盖默认里面的 header
  /// [body] 请求数据体
  /// [encoding] 请求编码，默认 UTF-8
  /// [errorTransform] 请求错误变换逻辑，可以用来解析错误内容
  Future<http.Response> post(String url,
      {Map<String, String> headers,
      ErrorTransform errorTransform = _defaultErrorTransform,
      dynamic body,
      Encoding encoding = utf8}) async {
    Map<String, String> finalHeaders = Map.from(_defaultRequestHeader);
    if (headers != null) {
      finalHeaders.addAll(headers);
    }
    try {
      url = _processRequest(url, finalHeaders, body);
      http.Response response = await http.post(url,
          headers: finalHeaders, encoding: encoding, body: body);
      if (response.statusCode == 200) {
        return response;
      }
      var error = HttpError(
          code: response.statusCode,
          message: "Http code: ${response.statusCode}",
          body: response.body);
      error.originException = error;
      throw error;
    } catch (e) {
      throw _onCatchError(e, errorTransform);
    }
  }

  PixivHttp._();

  HttpError _onCatchError(dynamic error, ErrorTransform errorTransform) {
    /// get error message
    HttpError httpError;
    if (error is HttpError) {
      httpError = error;
    } else {
      httpError = HttpError(code: -1)
        ..message = "Network error"
        ..originException = error;
    }

    /// global transform
    for (ErrorTransform transform in errorTransformMap.values) {
      if (transform != null) {
        httpError = transform(httpError);
      }
    }

    /// request transform
    if (errorTransform != null) {
      httpError = errorTransform(httpError);
    }
    return httpError;
  }

  String _processRequest(String url, Map<String, String> headers, dynamic body) {
    for (var intercept in requestInterceptMap.values) {
      url = intercept(url, headers, body);
    }
    return url;
  }
}
