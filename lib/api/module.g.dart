// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
