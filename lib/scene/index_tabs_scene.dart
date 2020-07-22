import 'package:flutter/material.dart';
import 'topics_scene.dart';
import 'stateful_page.dart';
import 'package:rc/routes_helper.dart';

class IndexTabsScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexTabsState();
  }
}

const TYPES = [
  {"name": "默认", "type": "last_actived"},
  {"name": "最新回复", "type": "recent"},
  {"name": "无人问津", "type": "no_reply"},
  {"name": "优质帖子", "type": "popular"},
  {"name": "精华帖子", "type": "excellent"}
];

class _IndexTabsState extends State<IndexTabsScene>
    with SingleTickerProviderStateMixin {
  var _tabController;

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = TYPES.map((item) => Tab(text: item['name'])).toList();
    List<Widget> children = TYPES
        .map((item) => KeepAliveWidget(
                child: TopicsScene(
              type: item['type'],
            )))
        .toList();

    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            tooltip: 'Add Topic',
            icon: Icon(Icons.add),
            onPressed: ()=> RoutesHelper.of(context).goAddTopic(),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabs,
        ),
        title: Text('首页'),
      ),
      body: TabBarView(
        children: children,
        controller: _tabController,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: TYPES.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


}
