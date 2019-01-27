// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedResponse _$RecommendedResponseFromJson(Map<String, dynamic> json) {
  return RecommendedResponse()
    ..illusts = (json['illusts'] as List)
        ?.map((e) =>
            e == null ? null : Illust.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$RecommendedResponseToJson(
        RecommendedResponse instance) =>
    <String, dynamic>{'illusts': instance.illusts};
