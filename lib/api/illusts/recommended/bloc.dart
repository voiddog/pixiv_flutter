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
import 'package:bloc/bloc.dart';
import 'module.dart';
import 'package:flutter/foundation.dart';
import 'package:pixiv_flutter/api/api.dart';
import 'repository.dart';

class RecommendBloc extends Bloc<RecommendedEvent, RecommendedState> {

  final AuthBloc authBloc;

  final RecommendedRepository repository;

  RecommendBloc({@required this.authBloc, @required this.repository})
      : assert(authBloc != null), assert(repository != null);

  @override
  RecommendedState get initialState => null;

  @override
  Stream<RecommendedState> mapEventToState(RecommendedState currentState, RecommendedEvent event) async* {
    if (event is RefreshRecommendedEvent) {
      yield new RefreshRecommendedState()
        ..isLoading = true;
      try {
        RecommendedResponse response = await repository.recommended(authBloc.authCode, null);
        yield new RefreshRecommendedState()
          ..data = response;
      } on HttpError catch (e) {
        yield new RefreshRecommendedState()
          ..message = e.message
          ..error = e;
      }
    }
  }

}