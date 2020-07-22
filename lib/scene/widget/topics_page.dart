import 'package:flutter/material.dart';
import 'package:rc/model/topic.dart';
import 'dart:async';
import 'package:rc/widget/topic_list_item.dart';
import 'package:rc/scene/topic_scene.dart';
import 'package:rc/widget/refresh_list_view.dart';
import 'package:rc/service/service.dart';

typedef Future<Result<List<Topic>>> FetchTopics(int limit, int offset);

class TopicsPage extends StatefulWidget {
  final bool showNodeButton;
  final FetchTopics fetchTopics;

  TopicsPage(this.fetchTopics, {Key key, this.showNodeButton = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _TopicsPage();
  }
}

class _TopicsPage extends State<TopicsPage> {
  List<Topic> _data = [];

  int _pageSize = 25;

  int _curPage = 1;

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

      widget.fetchTopics(_pageSize, (_curPage - 1) * _pageSize).then((res) {
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
    return RefreshListView(
      child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) => _buildRow(context, _data[index])),
      onRefresh: _pullToRefresh,
      loadMore: _loadMore,
    );
  }

  Widget _buildRow(BuildContext context, Topic topic) {
    return TopicListItem(topic,
        onTap: () => Navigator.of(context)
            .push(new MaterialPageRoute(builder: (ctx) => TopicScene(topic))),
//        onNodeButtonTap: () {
//          Navigator.of(context).push(new MaterialPageRoute(
//              builder: (ctx) => Scaffold(
//                    appBar: new AppBar(title: Text(topic.nodeName)),
//                    body: TopicsPage(
//                      nodeId: topic.nodeId,
//                      showNodeButton: false,
//                    ),
//                  )));
//        },
        showNodeButton: widget.showNodeButton);
  }
}
