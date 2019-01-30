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
/// @since 2019-01-29 21:32

import 'package:flutter/material.dart';
import 'package:pixiv_flutter/ui/ui.dart';

class IllustCard extends StatelessWidget {
  final String imgUrl;

  final String title;

  final double imgWidth;

  final double imgHeight;

  const IllustCard(
      {Key key, this.imgUrl, this.title, this.imgWidth = 1, this.imgHeight = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: AspectRatio(
            aspectRatio: imgWidth / imgHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Color(0x330D1751), offset: Offset(0, 10), blurRadius: 12)],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  image: DecorationImage(
                      image: PixivImage.createImageProvider(imgUrl))),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6.0, right: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  child: Text(
                title,
                style: TextStyle(color: Colors.black38, fontSize: 12),
              )),
              InkResponse(
                onTap: () {},
                radius: Material.defaultSplashRadius,
                child: Container(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.more_horiz,
                      size: 14,
                      color: Colors.black38,
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}
