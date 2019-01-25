// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
