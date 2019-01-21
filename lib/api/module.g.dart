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

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..account = json['account'] as String
    ..mailAddress = json['mail_address'] as String
    ..isPremium = json['is_premium'] as bool
    ..profileImgUrls = (json['profile_image_urls'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String))
    ..comment = json['comment'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'account': instance.account,
      'mail_address': instance.mailAddress,
      'is_premium': instance.isPremium,
      'profile_image_urls': instance.profileImgUrls,
      'comment': instance.comment
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse()
    ..accessToken = json['access_token'] as String
    ..tokenType = json['token_type'] as String
    ..refreshToken = json['refresh_token'] as String
    ..deviceToken = json['devoce_token'] as String
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
      'devoce_token': instance.deviceToken,
      'user': instance.user
    };
