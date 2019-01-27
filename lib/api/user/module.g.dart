// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
