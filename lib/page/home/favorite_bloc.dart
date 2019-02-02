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
/// @since 2019-02-01 15:37
///
import 'package:pixiv_flutter/bloc/bloc.dart';
import 'package:pixiv_flutter/api/api.dart';
import 'dart:async';

class FavoriteState {
  Map<int, Illust> favoriteIllusts = {};
}

class FavoriteEvent {}

class AddFavoriteEvent extends FavoriteEvent{
  final Illust illust;

  AddFavoriteEvent(this.illust);
}

class RemoveFavoriteEvent extends FavoriteEvent{
  final Illust illust;

  RemoveFavoriteEvent(this.illust);
}

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {

  final IllustsRepository repository;

  FavoriteBloc(this.repository);

  @override
  FavoriteState get initialState => FavoriteState();

  @override
  Stream<FavoriteState> mapEventToState(FavoriteState currentState, FavoriteEvent event) async* {
    if (event is AddFavoriteEvent) {
      Illust illust = event.illust;
      yield FavoriteState()
        ..favoriteIllusts = Map.from(currentState.favoriteIllusts)
        ..favoriteIllusts[illust.id] = illust;
      try {
        await repository.addBookmark(illust.id);
      } catch (e) {
        yield currentState;
      }
    } else if (event is RemoveFavoriteEvent) {
      Illust illust = event.illust;
      yield FavoriteState()
        ..favoriteIllusts.remove(illust.id);
      try {
        await repository.addBookmark(illust.id);
      } catch (e) {
        yield currentState;
      }
    }
  }
}