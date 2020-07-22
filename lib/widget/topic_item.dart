import 'package:flutter/material.dart';
import 'package:rc/model/topic_detail.dart';
import 'package:rc/widget/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:rc/widget/like.dart';
import 'package:rc/widget/markdown/md_viewer.dart';

class TopicItem extends StatelessWidget {
  TopicDetail topicDetail;

  int floor;

  Function onReplyButtonClick;

  Function onLikePress;

  TopicItem(
      this.topicDetail, this.floor, this.onReplyButtonClick, this.onLikePress);

  @override
  Widget build(BuildContext context) {
    return _buildRow(context, topicDetail, floor);
  }

  void _onPopMenuSelected(TopicItemActionMap map) {
    onReplyButtonClick(map);
  }

  Widget _buildRow(BuildContext context, TopicDetail detail, int floor) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                child: UserAvatar(detail.user),
                width: 32.0,
                height: 32.0,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(detail.user.login),
                      Text(timeago.format(detail.createdAt, locale: 'zh_CN'),
                          style: Theme.of(context).textTheme.caption),
                    ]),
              )),
              Like(
                detail.meta.liked,
                detail.likesCount,
                onLikePress,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(2, 8, 2, 0),
              child: MdViewer(
                data: detail.body,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                child:
                    Text('#$floor', style: Theme.of(context).textTheme.caption),
              ),
              Expanded(
                child: Container(),
              ),
              Align(
                alignment: FractionalOffset.centerRight,
                child: PopupMenuButton<TopicItemActionMap>(
                  icon: Icon(Icons.more_vert, size: 20, color: Colors.grey,),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  onSelected: _onPopMenuSelected,
                  itemBuilder: (context) => <PopupMenuItem<TopicItemActionMap>>[
                        PopupMenuItem<TopicItemActionMap>(
                          child: const Text('回复'),
                          enabled: topicDetail.closed == false,
                          value: TopicItemActionMap(TopicItemAction.REPLY, detail),
                        ),
//                        PopupMenuItem<TopicItemActionMap>(
//                          child: const Text('修改'),
//                          value: TopicItemActionMap(TopicItemAction.UPDATE, detail),
//                        ),
//                        PopupMenuItem<TopicItemActionMap>(
//                          child: const Text('删除'),
//                          value: TopicItemActionMap(TopicItemAction.DELETE, detail),
//                        ),
                        PopupMenuItem<TopicItemActionMap>(
                          child: const Text('复制'),
                          value: TopicItemActionMap(TopicItemAction.COPY, detail),
                        ),
                      ].where((_)=>_.enabled==true).toList(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

enum TopicItemAction { REPLY, UPDATE, DELETE, COPY }

class TopicItemActionMap {
  TopicItemAction action;
  TopicDetail detail;

  TopicItemActionMap(this.action, this.detail);
}
