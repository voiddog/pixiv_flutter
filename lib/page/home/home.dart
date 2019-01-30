import 'package:flutter/material.dart';
import 'package:pixiv_flutter/api/api.dart';
import 'package:pixiv_flutter/page/page.dart';
import 'package:pixiv_flutter/bloc/bloc.dart';
import 'bloc.dart';
import 'header.dart';
import 'package:pixiv_flutter/ui/ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'illust_card.dart';

class HomePage extends StatefulWidget {
  HomePage() : super();

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.dispatch(RefreshTokenEvent());
    _bloc = HomeBloc(authBloc: authBloc, repository: IllustsRepository());
    _bloc.dispatch(RefreshEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5fafe),
      body: BlocReceiver(
        bloc: BlocProvider.of<AuthBloc>(context),
        callback: (context, state) {
          /// 如果触发了登出，退出到登出界面
          if (state is Unauthenticated && state.isLogout) {
            Navigator.of(context).popUntil((route) {
              return route.isFirst;
            });
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          } else if (state is Authenticated && state.preState is TokenOverdue) {
            // need refresh
            _bloc.dispatch(RefreshEvent());
          }
        },
        child: BlocBuilder(bloc: _bloc, builder: _buildContent),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    if (state is RefreshingState) {
      if (state.isPageLoad) {
        return _createPageLoading(context, state);
      }
    } else if (state is ErrorState) {
      if (state.isRefresh) {
        return _createPageError(context, state);
      }
    } else if (state is EmptyState) {
      return _createPageEmpty(context, state);
    }
    return _createPageSliver(context, state);
  }

  /// 创建整页加载
  Widget _createPageLoading(BuildContext context, RefreshingState state) {
    return Column(
      children: <Widget>[
        HeadLayout(
            contentHeight: 200,
            curveHeight: 40,
            paddingTop: MediaQuery.of(context).padding.top),
        Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }

  /// 创建页面等级的错误
  Widget _createPageError(BuildContext context, ErrorState state) {
    if (state.errorCode == AuthBloc.CODE_ERROR_ACCESS_TOKEN) {
      BlocProvider.of<AuthBloc>(context).dispatch(TokenOverdueEvent());
    }
    return Column(
      children: <Widget>[
        HeadLayout(
          contentHeight: 200,
          curveHeight: 40,
          paddingTop: MediaQuery.of(context).padding.top,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${state.message}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: () {
                    if (state.errorCode == AuthBloc.CODE_ERROR_ACCESS_TOKEN) {
                      AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
                      authBloc.dispatch(RefreshTokenEvent());
                    } else {
                      _bloc.dispatch(RefreshEvent());
                    }
                  },
                  child: Text(
                    'Refersh',
                    style: TextStyle(color: Colors.grey),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      side: BorderSide(color: Colors.grey, width: 2)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _createPageEmpty(BuildContext context, EmptyState state) {
    return Column(
      children: <Widget>[
        HeadLayout(
          contentHeight: 200,
          curveHeight: 40,
          paddingTop: MediaQuery.of(context).padding.top,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.hourglass_empty,
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'No data',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: () {
                    _bloc.dispatch(RefreshEvent());
                  },
                  child: Text(
                    'Refresh',
                    style: TextStyle(color: Colors.grey),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      side: BorderSide(color: Colors.grey, width: 2)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _createPageSliver(BuildContext context, HomeState state) {
    List<Widget> sliver = [];

    /// add header
    sliver.add(SliverPersistentHeader(
        pinned: true,
        delegate: HeadDelegate(
            contentHeight: 200,
            closeHeight: kToolbarHeight,
            paddingTop: MediaQuery.of(context).padding.top,
            curveHeight: 40)));
    // images
    if (state is StateData) {
      sliver.add(SliverStaggeredGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (state.illusts.length - index < 5) {
              // need load more
              _bloc.dispatch(LoadMoreEvent());
            }
            var data = state.illusts[index];
            return IllustCard(
              imgUrl: data.imageUrls.previewUrl,
              imgWidth: data.width.toDouble(),
              imgHeight: data.height.toDouble(),
              title: data.title,
            );
          }, childCount: state.illusts.length),
          gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 6.0,
              staggeredTileBuilder: (int index) {
                return new StaggeredTile.fit(1);
              })));
    }
    if (state is LoadingMoreState) {
      sliver.add(SliverToBoxAdapter(
        child: Container(
          constraints: BoxConstraints.expand(height: 50),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ));
    }
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: sliver,
    );
  }
}
