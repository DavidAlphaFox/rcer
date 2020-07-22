import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rc/widget/refresh_list_view.dart';
import 'package:rc/service/service.dart';
import 'package:rc/model/user.dart';
import 'package:rc/model/reply.dart';
import 'package:rc/widget/user_replies_item.dart';
import 'package:rc/routes_helper.dart';


class UserRepliesScene extends StatefulWidget {
  final bool showNodeButton;
  final String loginId;

  UserRepliesScene({Key key, this.loginId, this.showNodeButton = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserRepliesState();
  }
}

class _UserRepliesState extends State<UserRepliesScene> {
  List<Reply> _data = [];

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
          .getUserReplies(
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
    String title = '${widget.loginId}的回帖';
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

  Widget _buildRow(BuildContext context, Reply reply) {
    return UserRepliesItem(reply, onTap: ()=>RoutesHelper.of(context).goTopicDetail(reply.topicId, reply.topicTitle),);

  }
}
