import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rc/model/topic_detail.dart';
import 'package:rc/widget/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

enum PopMenuAcion { REPLY, UPDATE, DELETE }

class TopicItem extends StatelessWidget {

  TopicDetail topicDetail;

  int floor;

  Function onReplyButtonClick;


  TopicItem(this.topicDetail, this.floor, this.onReplyButtonClick);

  @override
  Widget build(BuildContext context) {
    return _buildRow(context, topicDetail, floor);
  }


  void _onPopMenuSelected(ReplyActionMap map) {
    switch (map.action) {
      case PopMenuAcion.REPLY:
        onReplyButtonClick(map.reply.user.login);
        break;
      case PopMenuAcion.UPDATE:
        onReplyButtonClick('');
        break;
      case PopMenuAcion.DELETE:
        onReplyButtonClick('');
        break;
    }
  }

  Widget _buildRow(BuildContext context, TopicDetail detail, int floor) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(child: UserAvatar(detail.user), width: 32.0, height: 32.0,),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(detail.user.login),
                          Text(timeago.format(detail.createdAt,locale: 'zh_CN'), style: Theme.of(context).textTheme.caption),
                        ]),
                  )),
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){},
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    icon: Icon(Icons.favorite_border),

                  )
                  ,
                  Text(
                    '+${detail.likesCount}',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: MarkdownBody(
              data: detail.body,
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                child: Text('#$floor', style: Theme.of(context).textTheme.caption),
              ),
              Expanded(
                child: Container(),
              ),
              Align(
                alignment: FractionalOffset.centerRight,
                child: PopupMenuButton<ReplyActionMap>(
                  onSelected: _onPopMenuSelected,
                  itemBuilder: (context) => <PopupMenuItem<ReplyActionMap>>[
                    PopupMenuItem<ReplyActionMap>(
                      child: const Text('回复评论'),
                      value: ReplyActionMap(PopMenuAcion.REPLY, null),
                    ),
                    PopupMenuItem<ReplyActionMap>(
                      child: const Text('更改评论'),
                      value: ReplyActionMap(PopMenuAcion.UPDATE, null),
                    ),
                    PopupMenuItem<ReplyActionMap>(
                      child: const Text('删除评论'),
                      value: ReplyActionMap(PopMenuAcion.DELETE, null),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ReplyActionMap {
  PopMenuAcion action;
  TopicDetail reply;

  ReplyActionMap(this.action, this.reply);
}
