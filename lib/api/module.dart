import 'package:json_annotation/json_annotation.dart';
part 'module.g.dart';

/// 图片地址
@JsonSerializable()
class ImageUrls {
  String squareMedium;

  String medium;

  String large;

  String original;

  String get previewUrl {
    if (medium?.isNotEmpty == true) {
      return medium;
    } else if (large?.isNotEmpty == true) {
      return large;
    }
    return original;
  }

  ImageUrls();

  factory ImageUrls.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlsFromJson(json);
}

/// 数据加载装填
mixin DataLoadingState<T> {
  /// 是否是第一次加载
  bool isInitLoad = false;
  /// 是否是 loading 状态
  bool isLoading = false;
  /// 数据
  T data;
  /// 错误消息
  String message;
  /// 错误原型
  dynamic error;
  // 是否成功
  bool get isSuccess => error == null && !isLoading;
}