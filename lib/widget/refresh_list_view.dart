import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef Future<void> OnRefresh();
typedef Future<void> LoadMore();

class RefreshListView extends StatefulWidget {
  final OnRefresh onRefresh;

  final LoadMore loadMore;

  final ListView child;

  final showFirstLoader;

  RefreshListView(
      {this.onRefresh, this.child, this.loadMore, this.showFirstLoader = true});

  @override
  State<StatefulWidget> createState() {
    return _RefreshListViewState();
  }
}

class _RefreshListViewState extends State<RefreshListView>{
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      key: _easyRefreshKey,
      refreshHeader: BallPulseHeader(
        color: Theme.of(context).accentColor,
        key: _headerKey,
      ),
      refreshFooter: BallPulseFooter(
        color: Theme.of(context).accentColor,
        key: _footerKey,
      ),
      firstRefresh: true,
      onRefresh: widget.onRefresh,
      loadMore: widget.loadMore,
      firstRefreshWidget: widget.showFirstLoader
          ? new Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black12,
              child: new Center(
                  child: SizedBox(
                height: 120.0,
                width: 120.0,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        child: SpinKitFadingCube(
                          color: Theme.of(context).accentColor,
                          size: 25.0,
                        ),
                      ),
                      Container(
                        child: Text('正在加载'),
                      )
                    ],
                  ),
                ),
              )),
            )
          : null,
      child: widget.child,
    );
  }

}
