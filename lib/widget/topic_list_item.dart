import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rc/model/topic.dart';
import 'package:rc/widget/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class TopicListItem extends StatelessWidget {
  final Topic topic;

  final bool showNodeButton;

  final VoidCallback onTap;

  final VoidCallback onNodeButtonTap;

  TopicListItem(this.topic,
      {this.showNodeButton = false, this.onTap, this.onNodeButtonTap});

  @override
  Widget build(BuildContext context) {
    String date = topic.repliedAt == null
        ? timeago.format(topic.createdAt, locale: 'zh_CN')
        : timeago.format(topic.repliedAt, locale: 'zh_CN');
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                UserAvatar(topic.user),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(topic.user.login),
                        Text(
                          '$date  ${topic.repliesCount}评论  ${topic.likesCount}喜欢  ${topic.hits}点击',
                          style: Theme.of(context).textTheme.caption,
                        ),
//                        _buildTopicInfo(context, topic)
                      ],
                    ),
                  ),
                ),
                _buildNodeButton(context, topic)
              ],
            ),
            Text(
              topic.title.trim(),
              softWrap: true,
              style: Theme.of(context).textTheme.subhead,
            )
          ],
        ),
      ),
    );
  }

  _buildTopicInfo(BuildContext context, Topic topic) {
    TextStyle style = Theme.of(context).textTheme.caption;

    String dateStr = topic.repliedAt == null
        ? timeago.format(topic.createdAt, locale: 'zh_CN')
        : timeago.format(topic.repliedAt, locale: 'zh_CN');

    Tooltip dateTip = Tooltip(message:'', child: Icon(CupertinoIcons.time, size: style.fontSize * 1.1, color: style.color,),);
    Text date = Text('$dateStr  ', style: style,);

    Tooltip commentTip = Tooltip(message:'', child: Icon(CupertinoIcons.mail, size: style.fontSize * 1.1, color: style.color,),);
    Text  comment = Text('${topic.repliesCount}  ', style: style,);

    Tooltip likeTip = Tooltip(message:'', child: Icon(CupertinoIcons.heart, size: style.fontSize * 1.1, color: style.color,),);
    Text  like = Text('${topic.likesCount}  ', style: style,);

    Tooltip eyeTip = Tooltip(message:'', child: Icon(CupertinoIcons.eye, size: style.fontSize * 1.1, color: style.color,),);
    Text  eye = Text('${topic.hits}', style: style,);

    return Row(
      children: <Widget>[
        dateTip,
        date,
        commentTip,
        comment,
        likeTip,
        like,
        eyeTip,
        eye
      ],
    );


  }

  _buildNodeButton(BuildContext context, Topic topic) {
    if(showNodeButton) {
      return  InkWell(
        onTap: onNodeButtonTap,
        child: Chip(
          key:  ValueKey<Topic>(topic),
          label:  Text(topic.nodeName, style: Theme.of(context).textTheme.caption,),

        ),
      );
//      return SizedBox(
//        height: 32,
//        width: 64,
//        child: FlatButton(
//          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//          color: Colors.grey,
//          onPressed: onNodeButtonTap,
//          child: Text(
//            '${topic.nodeName}',
//            style: Theme.of(context).textTheme.caption,
//          ),
//        ),
//      );
    }

    return Container();
  }
}
