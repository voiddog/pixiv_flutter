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
import 'package:json_annotation/json_annotation.dart';
part 'module.g.dart';

@JsonSerializable()
class ErrorMessage {
  @JsonKey()
  String userMessage;
  @JsonKey()
  String message;
  @JsonKey()
  String reason;

  ErrorMessage();

  factory ErrorMessage.fromJson(Map<String, dynamic> json) => _$ErrorMessageFromJson(json);
}

class HttpError implements Exception {
  /// http 请求错误码 < 0 表示网络异常
  int code;
  /// 错误 body
  String body;
  /// 如果有，则表示源错误
  dynamic originException;
  /// 错误信息
  String message;

  HttpError({@required this.code, this.body, this.originException, this.message});
}