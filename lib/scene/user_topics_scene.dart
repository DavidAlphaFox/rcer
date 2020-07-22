import 'package:flutter/material.dart';
import 'package:rc/model/topic.dart';
import 'dart:async';
import 'package:rc/widget/topic_list_item.dart';
import 'package:rc/scene/topic_scene.dart';
import 'package:rc/widget/refresh_list_view.dart';
import 'package:rc/service/service.dart';
import 'package:rc/scene/topics_scene.dart';

class UserTopicsScene extends StatefulWidget {
  final bool showNodeButton;
  final String loginId;
  final String type;

  UserTopicsScene({Key key, this.loginId, this.type , this.showNodeButton = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _UserTopicsState();
  }
}

class _UserTopicsState extends State<UserTopicsScene> {
  List<Topic> _data = [];

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
          .getUserTopics(
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
    if(widget.type == 'topics') {
      title = '${widget.loginId}的话题';
    } else if(widget.type == 'favorites') {
      title = '${widget.loginId}收藏的话题';
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

  Widget _buildRow(BuildContext context, Topic topic) {
    return TopicListItem(topic,
        onTap: () => Navigator.of(context)
            .push(new MaterialPageRoute(builder: (ctx) => TopicScene(topic))),
        onNodeButtonTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (ctx) => Scaffold(
                    appBar: new AppBar(title: Text(topic.nodeName)),
                    body: TopicsScene(
                      nodeId: topic.nodeId,
                      showNodeButton: false,
                    ),
                  )));

        },
        showNodeButton: widget.showNodeButton);
  }
}
