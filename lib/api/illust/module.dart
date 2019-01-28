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
/// @since 2019-01-27 19:09
///
import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_flutter/api/api.dart';
part 'module.g.dart';

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
  int id;

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

@JsonSerializable()
class RecommendedResponse {
  List<Illust> illusts;

  List<Illust> rankingIllusts;

  String nextUrl;

  RecommendedResponse();

  factory RecommendedResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedResponseFromJson(json);
}