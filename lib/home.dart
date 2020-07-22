import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rc/scene/index_tabs_scene.dart';
import 'package:rc/scene/nodes_tab_page.dart';
import 'package:rc/scene/notice_scene.dart';
import 'package:rc/scene/user_info_scene.dart';
import 'package:rc/model/user.dart';



class AppHomeScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainStatePage();

  AppHomeScene({Key key}) : super(key: key);
}

class MainStatePage extends State<AppHomeScene> {
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: new IndexedStack(
          children: <Widget>[
            IndexTabsScene(),
            NodePage(),
            NoticeScene(null),
            UserInfoScene(User.fromJson({
              'login':'me'
            }, ), true, showSettingBtn: true,),
          ],
          index: _bottomNavIndex,
        ),
        bottomNavigationBar: new CupertinoTabBar(
            activeColor: Theme.of(context).accentColor,
            currentIndex: _bottomNavIndex,
            onTap: (index) {
              setState(() {
                _bottomNavIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), title: Text("首页")),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.collections), title: Text("节点")),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.mail), title: Text("通知")),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.profile_circled), title: Text("我")),
            ]),
      ),
    );
  }
}

class Empty extends StatelessWidget {
  final String name;

  Empty(this.name);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Text(name),
      ),
    );
  }
}
