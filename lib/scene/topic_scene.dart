import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:rc/model/models.dart';
import 'package:rc/repository/rc_repo.dart';
import 'package:rc/widget/reply_item.dart';
import 'package:rc/widget/topic_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rc/widget/reply_box.dart';
import 'package:rc/widget/refresh_list_view.dart';
import 'package:rc/service/service.dart';
import 'data_loader.dart';
import 'package:rc/constants.dart';
import 'package:rc/utils.dart';

class TopicScene extends StatefulWidget {
  final Topic topic;

  TopicScene(this.topic, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TopicSceneState();
  }
}

class _TopicSceneState extends State<TopicScene> {
  List _data = [];

  int _pageSize = 25;

  int _curPage = 1;

  final RCService _rcService = new RCService();

  RCRepo _rcRepo = new RCRepo();

  bool _likedTopic = false;

  bool _closed = false;

  @override
  void initState() {
    super.initState();
  }

  BuildContext _curContext;
  @override
  Widget build(BuildContext context) {
    _curContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('话题'),
        actions: <Widget>[
          PopupMenuButton<_ActionMap>(
            onSelected: onPopupMenuSelected,
            itemBuilder: _buildPopupMenu,
          ),
        ],
      ),
      body: RefreshListView(
        showFirstLoader: true,
        child: ListView.builder(
            itemCount: _data.length + 1,
            itemBuilder: (context, index) => _buildRow(context, index)),
        onRefresh: _pullToRefresh,
        loadMore: _loadMore,
      ),
    );
  }

  Widget _buildActionFavButton() {
    return !_likedTopic
        ? IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: Colors.grey[200],
            ),
            onPressed: () {},
          )
        : IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {},
          );
  }

  List<PopupMenuEntry<_ActionMap>> _buildPopupMenu(BuildContext context) {
    List<PopupMenuEntry<_ActionMap>> menus = [];


    final Topic topic = widget.topic;

    menus.add(_buildPopupMenuItem('分享', _ActionMap(_ActionType.SHARE, topic)));

    final TopicDetail topicDetail = _data.length >= 1 ? _data[0] : null;

    if(topicDetail != null) {
      final TopicAbilities abilities = topicDetail.abilities;

      if (abilities.update) {
        menus.add(
            _buildPopupMenuItem('修改话题', _ActionMap(_ActionType.UPDATE, topic)));
      }
      if (abilities.destroy) {
        menus.add(
            _buildPopupMenuItem('删除话题', _ActionMap(_ActionType.DESTROY, topic)));
      }
      if (abilities.close && !topicDetail.closed) {
        menus.add(
            _buildPopupMenuItem('关闭回复', _ActionMap(_ActionType.CLOSE, topic)));
      }
      if (abilities.open && topicDetail.closed) {
        menus.add(
            _buildPopupMenuItem('开启回复', _ActionMap(_ActionType.OPEN, topic)));
      }

      if (topicDetail != null && topicDetail.meta != null) {
        if (topicDetail.meta.followed) {
          menus.add(_buildPopupMenuItem(
              '取消关注', _ActionMap(_ActionType.UNFOLLOW, topic)));
        } else {
          menus.add(
              _buildPopupMenuItem('关注话题', _ActionMap(_ActionType.FOLLOW, topic)));
        }

        if (topicDetail.meta.favorited) {
          menus.add(_buildPopupMenuItem(
              '取消收藏', _ActionMap(_ActionType.UNFAVORITE, topic)));
        } else {
          menus.add(_buildPopupMenuItem(
              '收藏话题', _ActionMap(_ActionType.FAVORITE, topic)));
        }
      }



      if (abilities.ban) {
        menus
            .add(_buildPopupMenuItem('屏蔽话题', _ActionMap(_ActionType.BAN, topic)));
      }
      if (abilities.normal) {
        menus.add(
            _buildPopupMenuItem('NORMAL', _ActionMap(_ActionType.NORMAL, topic)));
      }
      if (abilities.excellent) {
        menus.add(
            _buildPopupMenuItem('加精华', _ActionMap(_ActionType.EXCELLENT, topic)));
      }
      if (abilities.unExcellent) {
        menus.add(_buildPopupMenuItem(
            '去掉精华', _ActionMap(_ActionType.UNEXCELLENT, topic)));
      }
    }

    return menus;
  }

  _buildPopupMenuItem(String title, _ActionMap map) {
    return PopupMenuItem(
      value: map,
      child: Text(title),
    );
  }

  void _fetchTopic() {
    _rcService.getTopicDetail(widget.topic.id).then((result) {
      if (result.isOk) {
        setState(() {
          _likedTopic = result.data.meta.liked;
          _closed = result.data.closed;
          _data.add(result.data);

          widget.topic.title = result.data.title;
        });
        _fetchData(false);
      }
    });
  }

  _buildRow(BuildContext context, int index) {
    if (index == 0) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Text(
          _closed ? '${widget.topic.title.trim()} (已关闭)' : widget.topic.title.trim(),
          style: Theme.of(context).textTheme.subhead,
        ),
      );
    }

    var item = _data[index - 1];

    if (item is TopicDetail) {
      return _buildTopicRow(context, item, index - 1);
    }

    if (item is Reply) {
      if (item.deleted) {
        return Container();
      }
      return _buildReplyRow(context, item, index - 1);
    }
  }

  _buildTopicRow(BuildContext context, TopicDetail detail, index) {
    final bool liked = detail.meta.liked;
    return InkWell(
      child: TopicItem(
          detail,
          index,
          (TopicItemActionMap map) =>
              _handleTopicMoreButtonPressed(context, map), () {
        _like(context, 'topic', detail.id, !liked, (res) {
          setState(() {
            detail.meta.liked = !liked;
            detail.likesCount = res.data.count;
          });
        });
      }),
    );
  }

  void _like(
      BuildContext context, String type, int id, bool like, Function callback) {
    var likeFunc = like ? _rcService.addLikes : _rcService.delLikes;
    DataLoader.of(context).load(() => likeFunc(type, id),
        onSuccess: callback, showDialog: showDialog);
  }

  _buildReplyRow(BuildContext context, Reply reply, index) {
    final bool liked = reply.liked;
    return InkWell(
      child: ReplyItem(
          reply,
          index,
          widget.topic.closed,
          (ReplyItemActionMap map) =>
              _handleReplyMoreButtonPressed(context, map), () {
        _like(context, 'reply', reply.id, !liked, (res) {
          setState(() {
            reply.liked = !liked;
            reply.likesCount = res.data.count;
          });
        });
      }),
    );
  }

  void _handleTopicMoreButtonPressed(
      BuildContext context, TopicItemActionMap map) {
    TopicDetail topicDetail = map.detail;
    switch (map.action) {
      case TopicItemAction.REPLY:
        _bottomSheetController = showBottomSheet(
            context: context,
            builder: (context) => ReplyBox(
                (newText) =>
                    _reply(widget.topic.id, newText, topicDetail.user.id),
                '回复话题'));
        break;
      case TopicItemAction.UPDATE:
        //_delReply(reply);
        break;
      case TopicItemAction.DELETE:
        //_delReply(reply);
        break;
      case TopicItemAction.COPY:
        Utils.copyToClipBoard(map.detail.body)
            .then((b) => Fluttertoast.showToast(msg: '操作成功'));
        break;
    }
  }

  PersistentBottomSheetController _bottomSheetController;
  void _handleReplyMoreButtonPressed(
      BuildContext context, ReplyItemActionMap map) {
    Reply reply = map.reply;
    switch (map.action) {
      case ReplyItemPopMenuAction.REPLY:
        _bottomSheetController = showBottomSheet(
            context: context,
            builder: (context) => ReplyBox(
                (newText) => _reply(widget.topic.id, newText, reply.id,),
                '回复${reply.user.login}', initValue: '@${reply.user.login} ',));
        break;
      case ReplyItemPopMenuAction.UPDATE:
        _bottomSheetController = showBottomSheet(
            context: context,
            builder: (context) => ReplyBox(
                (newText) => _updateReply(
                      reply,
                      reply.id,
                      newText,
                      reply.id,
                    ),
                '',
                initValue: reply.body));
        break;
      case ReplyItemPopMenuAction.DELETE:
        _delReply(reply);
        break;
      case ReplyItemPopMenuAction.COPY:
        Utils.copyToClipBoard(map.reply.body)
            .then((b) => Fluttertoast.showToast(msg: '操作成功'));
        break;
    }
  }

  void _reply(int id, String body, int replyToId) {
    DataLoader.of(context)
        .load(() => _rcService.reply(id, body, replyToId: replyToId),
            onSuccess: (res) {
      Fluttertoast.showToast(msg: '回复成功');
      if (_bottomSheetController != null) {
        _bottomSheetController.close();

        _fetchData(false);
//        setState(() {
//          _data.add(res.data);
//        });
      }
    }, showDialog: showDialog);
  }

  void _updateReply(Reply source, int id, String body, int replyToId) {
    DataLoader.of(context)
        .load(() => _rcService.updateReply(id, body, replyToId: replyToId),
            onSuccess: (res) {
      Fluttertoast.showToast(msg: '修改成功');
      if (_bottomSheetController != null) {
        _bottomSheetController.close();
      }
      int index = _data.indexOf(source);
      setState(() {
        _data.replaceRange(index, index + 1, [res.data]);
      });
    });
  }

  void _delReply(Reply reply) {
    DataLoader.of(context).load(() => _rcService.delReply(reply.id),
        onSuccess: (res) {
      Fluttertoast.showToast(msg: '删除成功');
      setState(() {
        _data.remove(reply);
      });
    });
  }

  Future<void> _pullToRefresh() async {
    _fetchTopic();
  }

  Future<void> _loadMore() async {
    _fetchData(true);
  }

  void _fetchData(bool isMore) {
    if (!isMore) {
      _curPage = 1;
      TopicDetail topic = _data[0];
      _data.clear();
      _data.add(topic);
    }
    _rcRepo
        .getReplies(widget.topic.id, _pageSize, (_curPage - 1) * _pageSize)
        .then((data) {
      if (data.isNotEmpty) {
        _curPage++;
        setState(() {
          _data.addAll(data);
        });
      }
    });
  }

  void onPopupMenuSelected(_ActionMap value) {
    TopicDetail topicDetail = _data[0];
    switch (value.type) {
      case _ActionType.UPDATE:
        Fluttertoast.showToast(msg: '开发中...');
        break;
      case _ActionType.DESTROY:
        DataLoader.of(context).load(() => _rcService.delTopic(widget.topic.id),
            showDialog: showDialog, onSuccess: (res) {
          Fluttertoast.showToast(msg: '删除成功');
          Navigator.of(_curContext).pop();
        });
        break;
      case _ActionType.BAN:
        Fluttertoast.showToast(msg: '开发中...');
        break;
      case _ActionType.NORMAL:
        Fluttertoast.showToast(msg: '开发中...');
        break;
      case _ActionType.EXCELLENT:
        Fluttertoast.showToast(msg: '开发中...');
        break;
      case _ActionType.UNEXCELLENT:
        Fluttertoast.showToast(msg: '开发中...');
        break;
      case _ActionType.CLOSE:
        _actionTopic('close', () {
          _fetchTopic();
          setState(() {
            topicDetail.closed = true;
          });
        });
        break;
      case _ActionType.OPEN:
        _actionTopic('open', () {
          _fetchTopic();
          setState(() {
            topicDetail.closed = true;
          });
        });
        break;
      case _ActionType.SHARE:
        FlutterShareMe()
            .shareToSystem(msg: '${HOST_URL}topics/${widget.topic.id}');
        break;
      case _ActionType.FOLLOW:
        _userActionTopic('follow', () {
          setState(() {
            topicDetail.meta.followed = true;
          });
        });
        break;
      case _ActionType.UNFOLLOW:
        _userActionTopic('unfollow', () {
          setState(() {
            topicDetail.meta.followed = false;
          });
        });

        break;
      case _ActionType.FAVORITE:
        _userActionTopic('favorite', () {
          setState(() {
            topicDetail.meta.favorited = true;
          });
        });
        break;
      case _ActionType.UNFAVORITE:
        _userActionTopic('unfavorite', () {
          setState(() {
            topicDetail.meta.favorited = false;
          });
        });
        break;
    }
  }

  void _actionTopic(String type, Function callback) {
    DataLoader.of(context).load(
        () => _rcService.actionTopic(widget.topic.id, type),
        showDialog: showDialog, onSuccess: (res) {
      Fluttertoast.showToast(msg: '操作成功');
      callback();
    });
  }

  void _userActionTopic(String type, Function callback) {
    DataLoader.of(context).load(
        () => _rcService.userActionTopic(widget.topic.id, type),
        showDialog: showDialog, onSuccess: (res) {
      Fluttertoast.showToast(msg: '操作成功');
      callback();
    });
  }
}

enum _ActionType {
  UPDATE,
  DESTROY,
  BAN,
  NORMAL,
  EXCELLENT,
  UNEXCELLENT,
  CLOSE,
  OPEN,
  SHARE,
  FOLLOW,
  UNFOLLOW,
  FAVORITE,
  UNFAVORITE
}

class _ActionMap {
  _ActionType type;
  var value;

  _ActionMap(this.type, this.value);
}
