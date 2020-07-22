import 'package:flutter/material.dart';
import 'package:rc/model/reply.dart';
import 'package:rc/widget/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:rc/widget/like.dart';
import 'package:rc/widget/markdown/md_viewer.dart';
import 'package:rc/constants.dart';

enum ReplyItemPopMenuAction { REPLY, UPDATE, DELETE, COPY }

class ReplyItem extends StatelessWidget {
  Reply reply;

  int floor;

  Function onReplyButtonClick;

  Function onLikePress;

  bool isTopicClosed;

  ReplyItem(this.reply, this.floor, this.isTopicClosed, this.onReplyButtonClick,
      this.onLikePress);

  @override
  Widget build(BuildContext context) {
    return _buildRow(context, reply, floor);
  }

  void _onPopMenuSelected(ReplyItemActionMap map) {
    onReplyButtonClick(map);
  }

  Widget _buildRow(BuildContext context, Reply reply, int floor) {
    bool closed = 'close' == reply.action;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                child: UserAvatar(reply.user),
                width: 32.0,
                height: 32.0,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(reply.user.login),
                      Text(timeago.format(reply.createdAt, locale: 'zh_CN'),
                          style: Theme.of(context).textTheme.caption),
                    ]),
              )),
              !closed && reply.action == null
                  ? Like(reply.liked, reply.likesCount, onLikePress)
                  : Container(),
            ],
          ),
          _build(reply),
          !closed && reply.action == null
              ? Row(
                  children: <Widget>[
                    SizedBox(
                      child: Text('#$floor',
                          style: Theme.of(context).textTheme.caption),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Align(
                      alignment: FractionalOffset.centerRight,
                      child: PopupMenuButton<ReplyItemActionMap>(
                        icon: Icon(Icons.more_vert, size: 20, color: Colors.grey),
                        onSelected: _onPopMenuSelected,
                        itemBuilder: (context) =>
                            <PopupMenuItem<ReplyItemActionMap>>[
                              PopupMenuItem<ReplyItemActionMap>(
                                child: const Text('回复'),
                                enabled: isTopicClosed == false,
                                value: ReplyItemActionMap(
                                    ReplyItemPopMenuAction.REPLY, reply),
                              ),
                              PopupMenuItem<ReplyItemActionMap>(
                                child: const Text('修改'),
                                enabled: reply.abilities.update,
                                value: ReplyItemActionMap(
                                    ReplyItemPopMenuAction.UPDATE, reply),
                              ),
                              PopupMenuItem<ReplyItemActionMap>(
                                child: const Text('删除'),
                                enabled: reply.abilities.destroy,
                                value: ReplyItemActionMap(
                                    ReplyItemPopMenuAction.DELETE, reply),
                              ),
                              PopupMenuItem<ReplyItemActionMap>(
                                child: const Text('复制'),
                                value: ReplyItemActionMap(
                                ReplyItemPopMenuAction.COPY, reply),
                              ),
                            ].where((_) => _.enabled == true).toList(),
                      ),
                    )
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  Widget _build(Reply reply) {
    String action = reply.action;
    if(action == 'close') {
      return Center(
        child: Text('关闭了讨论'),
      );
    } else if (action == 'reopen') {
      return Center(
        child: Text('重新开启了讨论'),
      );
    } else if(action == 'excellent') {
      // 将本帖设为了精华贴
      return Center(
        child: Text('将本帖设为了精华贴'),
      );
    } else if (action == 'mention' && reply.mentionTopic != null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(2, 8, 2, 0),
        child: MdViewer(
          data: '在[${reply.mentionTopic.title}](${HOST_URL}topics/${reply.mentionTopic.id})中提及了此帖',
        ),
      );
    }else  {
      return Padding(
        padding: EdgeInsets.fromLTRB(2, 8, 2, 0),
        child: MdViewer(
          data: reply.body,
        ),
      );
    }

  }
}

class ReplyItemActionMap {
  ReplyItemPopMenuAction action;
  Reply reply;

  ReplyItemActionMap(this.action, this.reply);
}
