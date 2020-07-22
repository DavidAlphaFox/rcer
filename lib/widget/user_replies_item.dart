import 'package:flutter/material.dart';
import 'package:rc/model/reply.dart';
import 'package:rc/widget/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:rc/widget/markdown/md_viewer.dart';

class UserRepliesItem extends StatelessWidget {
  final Reply reply;


  final VoidCallback onTap;


  UserRepliesItem(this.reply,
      {this.onTap});

  @override
  Widget build(BuildContext context) {
    String date = timeago.format(reply.updatedAt, locale: 'zh_CN');
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                UserAvatar(reply.user),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(reply.user.login),
                        Text(
                          '$date',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              reply.topicTitle,
              style: Theme.of(context).textTheme.subhead,
            ),
            MdViewer(data: reply.body,)
          ],
        ),
      ),
    );
  }
}
