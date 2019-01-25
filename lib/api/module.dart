import 'package:json_annotation/json_annotation.dart';
part 'module.g.dart';

@JsonSerializable()
class NetworkError implements Exception {
  int code;

  String message;

  String reason;

  NetworkError();

  factory NetworkError.fromJson(Map<String, dynamic> json) => _$NetworkErrorFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkErrorToJson(this);

  @override
  String toString() {
    return "code: $code\n"
        "message: $message\n"
        "reason: $reason";
  }
}

class AuthError implements Exception {

  final String message;

  AuthError({this.message = 'Not login error'});
}

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

/// 用户数据
@JsonSerializable()
class User {

  String id;

  String name;

  String account;

  ImageUrls profileImgUrls;

  String comment;

  bool isFollowed;

  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
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

/// 图片地址
@JsonSerializable()
class ImageUrls {
  String squareMedium;

  String medium;

  String large;

  String original;

  ImageUrls();

  factory ImageUrls.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlsFromJson(json);
}

/// 标签
@JsonSerializable()
class Tag {
  String name;

  Tag();

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

/// meta 单图
@JsonSerializable()
class MetaSinglePage {
  String originalImageUrl;

  MetaSinglePage();

  factory MetaSinglePage.fromJson(Map<String, dynamic> json) => _$MetaSinglePageFromJson(json);
}

/// 画报
@JsonSerializable()
class Illust {
  String id;

  String title;

  /// 图片类型: "illust". "manga"
  String type;

  ImageUrls imageUrls;

  /// 标题
  String caption;

  /// 限制: 0
  int restrict;

  User user;

  /// 插画标签
  List<Tag> tags;

  /// 插画使用的工具: ["SAI"]
  List<String> tools;

  /// 创建时间: "2019-01-20T00:03:40+09:00"
  String createDate;

  /// 当前画报内含有的图片数目: 1, 2
  int pageCount;

  /// 首图图片宽度
  int width;

  /// 首图图片高度
  int height;

  /// 理智等级: 2
  int sanityLevel;

  /// x 限制：0
  int xRestrict;

  MetaSinglePage metaSinglePage;

  List<ImageUrls> metaPages;

  int totalView;

  int totalBookmarks;

  int totalComments;

  bool isBookmarked;

  bool visible;

  bool isMuted;

  Illust();

  factory Illust.fromJson(Map<String, dynamic> json) => _$IllustFromJson(json);
}
