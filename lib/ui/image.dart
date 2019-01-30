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
/// @since 2019-01-29 01:59
///
import 'package:flutter/material.dart';

class PixivImage extends StatelessWidget {

  static NetworkImage createImageProvider(String url, {double scale = 1.0, }) {
    return NetworkImage(
      url,
      scale: scale,
      headers: {
        "user-agent": "PixivAndroidApp/5.0.108 (Android 6.0.1; MI 4LTE)",
        "referer": "https://app-api.pixiv.net/",
        "accept-encoding": "gzip"
      },
    );
  }

  final String src;

  final double scale;

  final double width;

  final double height;

  final BoxFit fit;

  PixivImage(this.src, {this.scale = 1.0, this.width, this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      this.src,
      width: this.width,
      height: this.height,
      scale: this.scale,
      headers: {
        "user-agent": "PixivAndroidApp/5.0.108 (Android 6.0.1; MI 4LTE)",
        "referer": "https://app-api.pixiv.net/",
        "accept-encoding": "gzip"
      },
    );
  }
}
