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
/// @since 2019-01-27 19:16
///
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:pixiv_flutter/api/api.dart';

part 'module.g.dart';

@JsonSerializable()
class RecommendedResponse {
  List<Illust> illusts;

  String nextUrl;

  RecommendedResponse();

  factory RecommendedResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendedResponseFromJson(json);
}

class RecommendedState {}

class RefreshRecommendedState extends RecommendedState
    with DataLoadingState<RecommendedResponse> {}

class NextRecommendedState extends RecommendedState
    with DataLoadingState<RecommendedResponse> {}

class RecommendedEvent {}

class RefreshRecommendedEvent extends RecommendedEvent {}

class NextRecommendedEvent extends RecommendedEvent {
  final String nextUrl;

  NextRecommendedEvent({@required this.nextUrl});
}
