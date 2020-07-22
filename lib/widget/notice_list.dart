import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NoticeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullUp: true,
        child: new ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return Text('text$index');
            }));
  }
}
