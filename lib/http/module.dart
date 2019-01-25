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
/// 数据请求模块
/// @author qigengxin
/// @since 2019-01-25 12:20
///
import 'package:flutter/foundation.dart';

class HttpError implements Exception {
  /// http 请求错误码 < 0 表示网络异常
  int code;
  /// 错误信息
  String message;
  /// 错误 body
  String body;
  /// 如果有，则表示源错误
  dynamic originException;

  HttpError({@required this.code, this.message, this.body, this.originException});
}