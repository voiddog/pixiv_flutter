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
import 'package:pixiv_flutter/api/api.dart';
import 'package:pixiv_flutter/bloc/bloc.dart';
import 'favorite_bloc.dart';

class IllustCard extends StatelessWidget {

  final Illust illust;

  const IllustCard({Key key, this.illust}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imgWidth = illust.width.toDouble();
    double imgHeight = illust.height.toDouble();
    FavoriteBloc favoriteBloc = BlocProvider.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: AspectRatio(
            aspectRatio: imgWidth / imgHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x330D1751),
                        offset: Offset(0, 10),
                        blurRadius: 12)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  image: DecorationImage(
                      image: PixivImage.createImageProvider(
                          illust.imageUrls.previewUrl))),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: BlocBuilder<FavoriteEvent, FavoriteState>(
                        bloc: favoriteBloc, builder: (context, state) {
                      bool isBookmarked = state.favoriteIllusts.containsKey(
                          illust.id);
                      if (!isBookmarked) {
                        isBookmarked = illust.isBookmarked;
                      }
                      return FavoriteButton(
                        isFavorite: isBookmarked, favoritePressed: () {
                          if (!isBookmarked) {
                            favoriteBloc?.dispatch(AddFavoriteEvent(illust));
                          } else {
                            favoriteBloc?.dispatch(RemoveFavoriteEvent(illust));
                          }
                      },);
                    }),
                  )
                ],
              ),
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
                    illust.title,
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

class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback favoritePressed;

  FavoriteButton({this.isFavorite = false, this.favoritePressed});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      color: Colors.transparent,
      child: InkResponse(
        onTap: widget.favoritePressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: Colors.transparent,
              elevation: 8,
              shape: CircleBorder(),
              shadowColor: widget.isFavorite ? Colors.red : Colors.black,
              child: Icon(
                Icons.favorite,
                color: widget.isFavorite ? Colors.red : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
