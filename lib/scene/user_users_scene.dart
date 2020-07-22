import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rc/widget/refresh_list_view.dart';
import 'package:rc/service/service.dart';
import 'package:rc/widget/user_avatar.dart';
import 'package:rc/model/user_detail.dart';
import 'package:rc/model/user.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:rc/routes_helper.dart';

class UserUsersScene extends StatefulWidget {
  final bool showNodeButton;
  final String loginId;
  final String type;

  UserUsersScene({Key key, this.loginId, this.type , this.showNodeButton = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _UserUsersState();
  }
}

class _UserUsersState extends State<UserUsersScene> {
  List<User> _data = [];

  int _pageSize = 25;

  int _curPage = 1;

  final RCService _rcService = new RCService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pullToRefresh() async {
    _fetchData(false);
  }

  Future<void> _loadMore() async {
    _fetchData(true);
  }

  void _fetchData(bool isMore) {
    try {
      if (!isMore) {
        _curPage = 1;
        _data.clear();
      }
      _rcService
          .getUserUsers(
          type: widget.type,
          limit: _pageSize,
          offset: (_curPage - 1) * _pageSize,
          loginId: widget.loginId)
          .then((res) {
        if (res.isOk) {
          _curPage++;
          setState(() {
            _data.addAll(res.data);
          });
        }
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    if(widget.type == 'blocked') {
      title = '${widget.loginId}屏蔽的用户';
    } else if(widget.type == 'following') {
      title = '${widget.loginId}关注的用户';
    } else if(widget.type == 'followers') {
      title = '关注${widget.loginId}的用户';
    }
    return Scaffold(
      appBar: AppBar(title: Text(title), ),
      body: RefreshListView(
        child: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) => _buildRow(context, _data[index])),
        onRefresh: _pullToRefresh,
        loadMore: _loadMore,
      ),
    );
  }

  Widget _buildRow(BuildContext context, User user) {
    return ListTile(
      leading: UserAvatar(user),
      title: Text('${user.login}'),
      subtitle: Text('No.${user.id}'),
      onTap: ()=> RoutesHelper.of(context).goUserInfo(user, false),
    );

  }
//    return TopicListItem(topic,
//        onTap: () => Navigator.of(context)
//            .push(new MaterialPageRoute(builder: (ctx) => TopicScene(topic))),
//        onNodeButtonTap: () {
//          Navigator.of(context).pop();
//          Navigator.of(context).push(new MaterialPageRoute(
//              builder: (ctx) => Scaffold(
//                appBar: new AppBar(title: Text(topic.nodeName)),
//                body: TopicsScene(
//                  nodeId: topic.nodeId,
//                  showNodeButton: false,
//                ),
//              )));
//
//        },
//        showNodeButton: widget.showNodeButton);
//  }
}
