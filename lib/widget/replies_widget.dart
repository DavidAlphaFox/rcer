import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rc/model/reply.dart';
import 'package:rc/utils.dart';
import 'package:rc/widget/user_avatar.dart';

enum PopMenuAcion { REPLY, UPDATE, DELETE }

class RepliesWidget extends StatelessWidget {
  List<Reply> replies;

  RepliesWidget(this.replies, this.onReplyButtonClick);

  Function onReplyButtonClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildSuggestions(context),
    );
  }

  List<Widget> _buildSuggestions(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < replies.length; i++) {
      list.add(_buildRow(context, replies[i], i));
    }
    return list;
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

  Widget _buildRow(BuildContext context, Reply reply, int floor) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(child: UserAvatar(reply.user), width: 32.0, height: 32.0,),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(reply.user.login),
                      Text(Utils.format(reply.createdAt))
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
                    '+${reply.likesCount}',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
            child: MarkdownBody(
              data: reply.body,
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                child: Text('#$floor'),
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
                          value: ReplyActionMap(PopMenuAcion.REPLY, reply),
                        ),
                        PopupMenuItem<ReplyActionMap>(
                          child: const Text('更改评论'),
                          enabled: reply.abilities.update,
                          value: ReplyActionMap(PopMenuAcion.UPDATE, reply),
                        ),
                        PopupMenuItem<ReplyActionMap>(
                          child: const Text('删除评论'),
                          enabled: reply.abilities.destroy,
                          value: ReplyActionMap(PopMenuAcion.DELETE, reply),
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
  Reply reply;

  ReplyActionMap(this.action, this.reply);
}
