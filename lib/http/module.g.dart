// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorMessage _$ErrorMessageFromJson(Map<String, dynamic> json) {
  return ErrorMessage()
    ..userMessage = json['user_message'] as String
    ..message = json['message'] as String
    ..reason = json['reason'] as String;
}

Map<String, dynamic> _$ErrorMessageToJson(ErrorMessage instance) =>
    <String, dynamic>{
      'user_message': instance.userMessage,
      'message': instance.message,
      'reason': instance.reason
    };
