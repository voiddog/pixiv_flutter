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
/// @since 2019-01-27 19:14
import 'package:pixiv_flutter/http/http.dart';
import 'package:pixiv_flutter/api/api.dart';
import 'dart:convert';

class IllustsRepository {

  /// 推荐信息
  Future<RecommendedResponse> recommended(String auth, String nextUrl) async {
    assert(auth != null);
    Map<String, String> header = {
      "authorization": auth
    };
    final response = await Http.get(
        nextUrl ?? "https://app-api.pixiv.net/v1/illust/recommended?filter=for_android&include_ranking_illusts=true&include_privacy_policy=true",
        headers: header
    );
    return RecommendedResponse.fromJson(jsonDecode(response.body));
  }
}