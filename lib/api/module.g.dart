// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkError _$NetworkErrorFromJson(Map<String, dynamic> json) {
  return NetworkError()
    ..code = json['code'] as int
    ..message = json['message'] as String
    ..reason = json['reason'] as String;
}

Map<String, dynamic> _$NetworkErrorToJson(NetworkError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'reason': instance.reason
    };

LoginUser _$LoginUserFromJson(Map<String, dynamic> json) {
  return LoginUser()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..account = json['account'] as String
    ..mailAddress = json['mail_address'] as String
    ..isPremium = json['is_premium'] as bool
    ..profileImgUrls = (json['profile_img_urls'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String))
    ..comment = json['comment'] as String
    ..isMailAuthorized = json['is_mail_authorized'] as bool;
}

Map<String, dynamic> _$LoginUserToJson(LoginUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'account': instance.account,
      'mail_address': instance.mailAddress,
      'is_premium': instance.isPremium,
      'profile_img_urls': instance.profileImgUrls,
      'comment': instance.comment,
      'is_mail_authorized': instance.isMailAuthorized
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..account = json['account'] as String
    ..profileImgUrls = json['profile_img_urls'] == null
        ? null
        : ImageUrls.fromJson(json['profile_img_urls'] as Map<String, dynamic>)
    ..comment = json['comment'] as String
    ..isFollowed = json['is_followed'] as bool;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'account': instance.account,
      'profile_img_urls': instance.profileImgUrls,
      'comment': instance.comment,
      'is_followed': instance.isFollowed
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse()
    ..accessToken = json['access_token'] as String
    ..tokenType = json['token_type'] as String
    ..refreshToken = json['refresh_token'] as String
    ..deviceToken = json['device_token'] as String
    ..user = json['user'] == null
        ? null
        : LoginUser.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
      'device_token': instance.deviceToken,
      'user': instance.user
    };

ImageUrls _$ImageUrlsFromJson(Map<String, dynamic> json) {
  return ImageUrls()
    ..squareMedium = json['square_medium'] as String
    ..medium = json['medium'] as String
    ..large = json['large'] as String
    ..original = json['original'] as String;
}

Map<String, dynamic> _$ImageUrlsToJson(ImageUrls instance) => <String, dynamic>{
      'square_medium': instance.squareMedium,
      'medium': instance.medium,
      'large': instance.large,
      'original': instance.original
    };

Tag _$TagFromJson(Map<String, dynamic> json) {
  return Tag()..name = json['name'] as String;
}

Map<String, dynamic> _$TagToJson(Tag instance) =>
    <String, dynamic>{'name': instance.name};

MetaSinglePage _$MetaSinglePageFromJson(Map<String, dynamic> json) {
  return MetaSinglePage()
    ..originalImageUrl = json['original_image_url'] as String;
}

Map<String, dynamic> _$MetaSinglePageToJson(MetaSinglePage instance) =>
    <String, dynamic>{'original_image_url': instance.originalImageUrl};

Illust _$IllustFromJson(Map<String, dynamic> json) {
  return Illust()
    ..id = json['id'] as String
    ..title = json['title'] as String
    ..type = json['type'] as String
    ..imageUrls = json['image_urls'] == null
        ? null
        : ImageUrls.fromJson(json['image_urls'] as Map<String, dynamic>)
    ..caption = json['caption'] as String
    ..restrict = json['restrict'] as int
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..tags = (json['tags'] as List)
        ?.map((e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..tools = (json['tools'] as List)?.map((e) => e as String)?.toList()
    ..createDate = json['create_date'] as String
    ..pageCount = json['page_count'] as int
    ..width = json['width'] as int
    ..height = json['height'] as int
    ..sanityLevel = json['sanity_level'] as int
    ..xRestrict = json['x_restrict'] as int
    ..metaSinglePage = json['meta_single_page'] == null
        ? null
        : MetaSinglePage.fromJson(
            json['meta_single_page'] as Map<String, dynamic>)
    ..metaPages = (json['meta_pages'] as List)
        ?.map((e) =>
            e == null ? null : ImageUrls.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..totalView = json['total_view'] as int
    ..totalBookmarks = json['total_bookmarks'] as int
    ..totalComments = json['total_comments'] as int
    ..isBookmarked = json['is_bookmarked'] as bool
    ..visible = json['visible'] as bool
    ..isMuted = json['is_muted'] as bool;
}

Map<String, dynamic> _$IllustToJson(Illust instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'image_urls': instance.imageUrls,
      'caption': instance.caption,
      'restrict': instance.restrict,
      'user': instance.user,
      'tags': instance.tags,
      'tools': instance.tools,
      'create_date': instance.createDate,
      'page_count': instance.pageCount,
      'width': instance.width,
      'height': instance.height,
      'sanity_level': instance.sanityLevel,
      'x_restrict': instance.xRestrict,
      'meta_single_page': instance.metaSinglePage,
      'meta_pages': instance.metaPages,
      'total_view': instance.totalView,
      'total_bookmarks': instance.totalBookmarks,
      'total_comments': instance.totalComments,
      'is_bookmarked': instance.isBookmarked,
      'visible': instance.visible,
      'is_muted': instance.isMuted
    };
