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
/// @since 2019-01-27 19:51
import 'package:pixiv_flutter/http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:pixiv_flutter/api/api.dart';
import 'package:pixiv_flutter/bloc/bloc.dart';

class HomeState {
}

class IdleState extends HomeState {}

mixin StateData on HomeState {
  List<Illust> illusts = [];
  List<Illust> rankingIllusts = [];
  String nextUrl;

  StateData from(StateData other) {
    illusts.addAll(other.illusts);
    rankingIllusts.addAll(other.rankingIllusts);
    nextUrl = other.nextUrl;
    return this;
  }
}

class RefreshingState extends HomeState with StateData {
  bool waitingForNewToken = false;
  bool isPageLoad = false;
}

class LoadingMoreState extends HomeState with StateData {
  bool waitingForNewToken = false;
}

class NewDataState extends HomeState with StateData {
  bool isRefresh = false;
}

class EmptyState extends HomeState {}

class CompleteState extends HomeState with StateData {}

class ErrorState extends HomeState with StateData {
  int errorCode = -1;
  bool isRefresh = false;
  String message;
}

class HomeEvent {}

class RefreshEvent extends HomeEvent {
  bool waitingForNewToken = false;
}

class LoadMoreEvent extends HomeEvent {
  bool waitingForNewToken = false;
}

class OnNewTokenGetEvent extends HomeEvent {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final IllustsRepository repository;

  HomeBloc({@required this.repository})
    : assert(repository != null);

  @override
  HomeState get initialState => IdleState();

  @override
  Stream<HomeState> mapEventToState(HomeState currentState, HomeEvent event) async* {
    if (currentState is IdleState) {
      if (event is RefreshEvent) {
        yield new RefreshingState()
          ..isPageLoad = true;
        yield* refresh(currentState);
      }
    } else if (currentState is EmptyState) {
      if (event is RefreshEvent) {
        yield new RefreshingState()
          ..isPageLoad=true;
        yield* refresh(currentState);
      }
    } else if (currentState is CompleteState) {
      if (event is RefreshEvent) {
        yield new RefreshingState()
            ..from(currentState);
        yield* refresh(currentState);
      }
    } else if (currentState is NewDataState) {
      if (event is RefreshEvent) {
        yield new RefreshingState()
          ..from(currentState);
        yield* refresh(currentState);
      } else if (event is LoadMoreEvent) {
        yield new LoadingMoreState()
          ..from(currentState);
        yield* loadMore(currentState, currentState.nextUrl);
      }
    } else if (currentState is ErrorState) {
      if (event is RefreshEvent) {
        yield new RefreshingState()
            ..waitingForNewToken = event.waitingForNewToken
            ..isPageLoad = currentState.illusts?.isNotEmpty != true
            ..from(currentState);
        if (!event.waitingForNewToken) {
          yield* refresh(currentState);
        }
      } else if (event is LoadMoreEvent) {
        yield new LoadingMoreState()
            ..waitingForNewToken = event.waitingForNewToken
            ..from(currentState);
        if (!event.waitingForNewToken) {
          yield* loadMore(currentState, currentState.nextUrl);
        }
      }
    } else if (currentState is RefreshingState) {
      if (event is OnNewTokenGetEvent && currentState.waitingForNewToken) {
        yield* refresh(currentState);
      }
    } else if (currentState is LoadingMoreState) {
      if (event is OnNewTokenGetEvent && currentState.waitingForNewToken) {
        yield* loadMore(currentState, currentState.nextUrl);
      }
    }
  }

  Stream<HomeState> refresh(HomeState state) async* {
    try {
      RecommendedResponse response = await repository.recommended(null);
      if (response == null || response.illusts?.isNotEmpty != true) {
        yield new EmptyState();
      } else {
        yield new NewDataState()
          ..illusts = response.illusts
          ..rankingIllusts = response.rankingIllusts
          ..nextUrl = response.nextUrl
          ..isRefresh = true;
      }
    } on HttpError catch (e) {
      var next = new ErrorState()
          ..errorCode = e.code
          ..isRefresh = true
          ..message = e.message;
      if (state is StateData) {
        next.from(state);
      }
      yield next;
    }
  }

  Stream<HomeState> loadMore(StateData state, String nextUrl) async* {
    try {
      RecommendedResponse response = await repository.recommended(nextUrl);
      if (response == null || response.illusts?.isNotEmpty != true) {
        yield new CompleteState().from(state);
      } else {
        yield new NewDataState()
            ..isRefresh = false
            ..from(state)
            ..illusts.addAll(response.illusts)
            ..rankingIllusts.addAll(response.rankingIllusts)
            ..nextUrl = response.nextUrl;
      }
    } on HttpError catch (e) {
      yield new ErrorState()
          ..from(state)
          ..errorCode = e.code
          ..isRefresh = false
          ..message = e.message;
    }
  }
}