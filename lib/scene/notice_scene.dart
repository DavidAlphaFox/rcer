import 'package:flutter/material.dart';
import 'package:rc/repository/rc_repo.dart';
import 'package:rc/model/models.dart' as models;
import 'package:rc/widget/user_avatar.dart';
import 'package:rc/scene/topic_scene.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provide/provide.dart';
import 'package:rc/service/service.dart';
import 'package:rc/app_state.dart';
import 'package:rc/routes_helper.dart';
import 'package:rc/widget/refresh_list_view.dart';

class NoticeScene extends StatefulWidget {
  final RCRepo rcRepo;

  NoticeScene(this.rcRepo);

  @override
  State<StatefulWidget> createState() {
    return _NoticeSceneState();
  }
}

class _NoticeSceneState extends State<NoticeScene>
    with SingleTickerProviderStateMixin {
  final int _pageSize = 15;

  int _curPage = 1;

  List<models.Notification> _data = [];

  RCRepo _rcRepo = new RCRepo();

  RCService rcService = new RCService();

  @override
  Widget build(BuildContext context) {
    AppState appState = Provide.value<AppState>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('通知'),
        ),
        body: !appState.isLogin
            ? Center(
                child: FlatButton(
                  onPressed: () {
                    RoutesHelper.of(context).goLogin();
                  },
                  child: Text('点击登录'),
                ),
              )
            : Center(
                child: RefreshListView(
                  loadMore: _loadMore,
                  child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) =>
                          _buildRow(context, _data[index])),
                  onRefresh: _pullToRefresh,
                ),
              ));
  }

  Widget _buildRow(BuildContext context, models.Notification notice) {
    models.User actor = notice.actor;
    models.Topic topic = notice.topic;

    return InkWell(
      child: Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 4,
                      height: 48,
//                      color:
//                          !notice.read ? Theme.of(context).accentColor : null,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: UserAvatar(actor)),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildRowCenter(notice)),
                      ),
                    ),
                    PopupMenuButton<_ItemActionMap>(
                      icon: Icon(Icons.more_vert, size: 20, color: Colors.grey),
                      onSelected: _onItemPopSelected,
                      itemBuilder: (BuildContext context) => [
//                            PopupMenuItem(
//                              child: Text('设为已读'),
//                              value: _ItemActionMap(notice, _ItemAction.READ),
//                            ),
                        PopupMenuItem(
                          child: Text('删除'),
                          value: _ItemActionMap(notice, _ItemAction.DEL),
                        )
                      ],
                    )
                  ],
                ),
              ],
            )),
      ),
      onTap: () {
        _setNotificationsRead(notice);
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (ctx) => TopicScene(topic)));
      },
    );
  }

  void _setNotificationsRead(models.Notification notice) {
    _rcRepo.setNotificationsRead([notice.id]).then((_) {
      setState(() {
        notice.read = true;
      });
    });

    rcService.setNotificationsRead().then((_){
      setState(() {
        _data.where((_)=>!_.read).map((_)=>_.read=true);
      });
    });
  }

  void _delNotification(models.Notification notice) {
    _rcRepo.delNotification(notice.id);
    setState(() {
      _data.remove(notice);
    });
  }

  List<Widget> _buildRowCenter(models.Notification notice) {
    models.User actor = notice.actor;
    models.Topic topic = notice.topic;

    var timeagoWidget = Align(
      alignment: Alignment.centerRight,
      child: Text(
        timeago.format(notice.createdAt, locale: 'zh_CN'),
        style: Theme.of(context).textTheme.caption,
      ),
    );

    if ('TopicReply' == notice.type) {
      return [
        Text(
          '用户${actor.login}回复了主题：',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          '${topic.title.trim()}',
          style: Theme.of(context).textTheme.subhead,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        timeagoWidget
      ];
    } else if ('Mention' == notice.type) {
      return [
        Text(
          '用户${actor.login}回复了主题中的评论：',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.caption,
        ),
        Text(
          '${topic.title}',
          style: Theme.of(context).textTheme.subhead,
        ),
        timeagoWidget
      ];
    } else {
      return [Text('暂不支持该通知，点击查看详情'), timeagoWidget];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pullToRefresh() async {
    _fetchData(false);
  }

  Future<void> _loadMore() async {
    _fetchData(true);
  }

  void _fetchData(bool isMore) {
    if (!isMore) {
      _curPage = 1;
      _data.clear();
    }
    rcService
        .getNotifications(_pageSize, (_curPage - 1) * _pageSize)
        .then((result) {
      if (result.isOk) {
        _curPage++;
        setState(() {
          _data.addAll(result.data);
        });
      } else {
        Fluttertoast.showToast(msg: result.message);
      }
    });
  }

  void _onItemPopSelected(_ItemActionMap value) {
    switch (value.action) {
      case _ItemAction.READ:
        _setNotificationsRead(value.notice);
        break;
      case _ItemAction.DEL:
        _delNotification(value.notice);
        break;
    }
  }
}

enum _ItemAction { READ, DEL }

class _ItemActionMap {
  models.Notification notice;
  _ItemAction action;

  _ItemActionMap(this.notice, this.action);
}
