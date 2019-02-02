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
import 'dart:async';

class IllustsRepository {

  /// 推荐信息
  Future<RecommendedResponse> recommended(String nextUrl) async {
    final response = await PixivHttp.instance.get(
        nextUrl ?? "https://app-api.pixiv.net/v1/illust/recommended?filter=for_android&include_ranking_illusts=true&include_privacy_policy=true",
    );
    return RecommendedResponse.fromJson(jsonDecode(response.body));
  }

  Future<String> addBookmark(int illustId, {String restrict = "public"}) async {
    final response = await PixivHttp.instance.post("https://app-api.pixiv.net/v2/illust/bookmark/add", body: {
      "illust_id": illustId.toString(),
      "restrict": restrict ?? "public"
    });
    return response.body;
  }

  Future<String> removeBookmark(int illustId) async {
    final response = await PixivHttp.instance.post("https://app-api.pixiv.net/v1/illust/bookmark/delete", body: {
      "illust_id": illustId.toString()
    });
    return response.body;
  }
}