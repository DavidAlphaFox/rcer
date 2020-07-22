import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rc/model/user_detail.dart';

import 'package:provide/provide.dart';
import 'package:rc/app_state.dart';
import 'package:rc/routes_helper.dart';
import 'package:rc/widget/refresh_list_view.dart';
import 'package:rc/service/service.dart';
import 'package:rc/model/models.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rc/utils.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'data_loader.dart';

class UserInfoScene extends StatefulWidget {
  final User user;
  final bool isSelf;
  final bool showSettingBtn;

  UserInfoScene(this.user, this.isSelf, {this.showSettingBtn = false});

  @override
  State<StatefulWidget> createState() {
    return _UserInfoState();
  }
}

class _UserInfoState extends State<UserInfoScene> {
  final RCService rcService = new RCService();

  UserDetail _userDetail;

  void _fetchData() {
    rcService.getUserDetail(loginId: widget.user.login).then((res) {
      if (res.isOk) {
        setState(() {
          _userDetail = res.data;
        });
      } else {
        Fluttertoast.showToast(msg: res.message);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = Provide.value<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('基本信息'),
        actions: <Widget>[
          widget.showSettingBtn
              ? IconButton(
                  icon: Icon(Icons.settings),
                  tooltip: '设置',
                  onPressed: () {
                    RoutesHelper.of(context).goSettings();
                  },
                )
              : Container()
        ],
      ),
      body: (widget.isSelf && !appState.isLogin)
          ? Center(
              child: FlatButton(
                onPressed: () {
                  RoutesHelper.of(context).goLogin();
                },
                child: Text('点击登录'),
              ),
            )
          : RefreshListView(
              showFirstLoader: true,
              onRefresh: () {
                _fetchData();
              },
              child: ListView(
                children: <Widget>[
                  _userDetail != null
                      ? UserSummary(_userDetail, widget.isSelf, (type) {
                          DataLoader.of(context).load(
                              () => rcService.userUserAction(
                                  _userDetail.login, type),
                              onSuccess: (result) {
                            Fluttertoast.showToast(msg: '操作成功');
                            _fetchData();
                          }, showDialog: showDialog);
                        })
                      : Container(),
                  ListTile(
                    leading: Icon(Icons.archive),
                    title: Text('话题'),
                    onTap: () {
                      _onTap(context, _Item.TOPICS);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.comment),
                    title: Text('回帖'),
                    onTap: () => _onTap(context, _Item.REPLIES),
                  ),
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('收藏'),
                    onTap: () => _onTap(context, _Item.FAVORITE),
                  ),
                  widget.isSelf
                      ? ListTile(
                          leading: Icon(GroovinMaterialIcons.eye_off),
                          title: Text('屏蔽的用户'),
                          onTap: () => _onTap(context, _Item.BLOCKED),
                        )
                      : Container(),
                  ListTile(
                    leading: Icon(Icons.remove_red_eye),
                    title: Text('关注的用户'),
                    onTap: () => _onTap(context, _Item.FOLLOWING),
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('关注者'),
                    onTap: () => _onTap(context, _Item.FOLLOWER),
                  ),
                ],
              ),
            ),
    );
  }

  void _onTap(BuildContext context, _Item item) {
    if (_userDetail == null && widget.isSelf) {
      Fluttertoast.showToast(msg: '请先登录');
    }

    switch (item) {
      case _Item.TOPICS:
        RoutesHelper.of(context).goUserTopics(_userDetail.login, 'topics');
        break;
      case _Item.FAVORITE:
        RoutesHelper.of(context).goUserTopics(_userDetail.login, 'favorites');
        break;
      case _Item.BLOCKED:
        RoutesHelper.of(context).goUserUsers(_userDetail.login, 'blocked');
        break;
      case _Item.FOLLOWING:
        RoutesHelper.of(context).goUserUsers(_userDetail.login, 'following');
        break;
      case _Item.FOLLOWER:
        RoutesHelper.of(context).goUserUsers(_userDetail.login, 'followers');
        break;
      case _Item.REPLIES:
        RoutesHelper.of(context).goUserReplies(_userDetail.login);
        break;
    }
  }
}

enum _Item { TOPICS, REPLIES, FAVORITE, FOLLOWING, FOLLOWER, BLOCKED }

class UserSummary extends StatelessWidget {
  final UserDetail user;
  final isSlef;
  final Function onBtnTap;
  UserSummary(this.user, this.isSlef, this.onBtnTap);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _buildBackground(
        theme,
        Container(
          padding: EdgeInsets.fromLTRB(32, 16, 4, 16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text('简介'),
                                      content: Html(
                                        data: user.bio ?? '这个人比较羞涩，啥也没说',
                                        onLinkTap: (url) => _lauchUrl(url),
                                      ),
                                    ));
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(user.avatarUrl),
                          ),
                        ),
                      ),
                      Text(
                        '${user.levelName}',
                        style: theme.textTheme.caption.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(32, 8, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'No.${user.id}',
                          style: theme.textTheme.subhead.copyWith(color: Colors.white),
                        ),
                        Text('${user.login}(${user.name})', style: theme.textTheme.body1.copyWith(color: Colors.white),),
                        Text('加入于${Utils.format(user.createdAt)}',style: theme.textTheme.body1.copyWith(color: Colors.white)),
                        _buildLocationInfo(user.location, user.company, theme.textTheme.body1.copyWith(color: Colors.white)),
                        Row(
                          children: <Widget>[
                            _buildToolTip(theme, GroovinMaterialIcons.email,
                                'mailto:', user.email, 'Email'),
                            _buildToolTip(
                                theme,
                                GroovinMaterialIcons.google_chrome,
                                null,
                                user.website,
                                '个人网站'),
                            _buildToolTip(
                                theme,
                                GroovinMaterialIcons.twitter,
                                'https://twitter.com/',
                                user.twitter,
                                'Twitter'),
                            _buildToolTip(
                                theme,
                                GroovinMaterialIcons.github_box,
                                'https://github.com/',
                                user.github,
                                'Github'),
                          ],
                        ),
                        !isSlef
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  user.userMeta.followed
                                      ? RaisedButton.icon(
                                          onPressed: () => onBtnTap('unfollow'),
                                          icon:
                                              Icon(GroovinMaterialIcons.human),
                                          color: theme.primaryColorDark,
                                          textColor: Colors.white,
                                          label: Text('取消关注'))
                                      : RaisedButton.icon(
                                          onPressed: () => onBtnTap('follow'),
                                          icon:
                                              Icon(GroovinMaterialIcons.human),
                                          color: theme.accentColor,
                                          textColor: Colors.white,
                                          label: Text('关注')),
                                  Container(
                                    width: 20,
                                  ),
                                  user.userMeta.blocked
                                      ? RaisedButton.icon(
                                          onPressed: () => onBtnTap('unblock'),
                                          color: theme.primaryColorDark,
                                          textColor: Colors.white,
                                          icon: Icon(
                                              GroovinMaterialIcons.eye_off),
                                          label: Text('取消屏蔽'))
                                      : RaisedButton.icon(
                                          onPressed: () => onBtnTap('block'),
                                          color: theme.accentColor,
                                          textColor: Colors.white,
                                          icon: Icon(
                                              GroovinMaterialIcons.eye_off),
                                          label: Text('屏蔽')),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildLocationInfo(String location, String company, TextStyle style) {
    if ((location == null || location.isEmpty) &&
        (company == null || company.isEmpty)) {
      return Container();
    }

    location = location == null || location.isEmpty ? '' : '@$location';
    company = company ?? '';
    return Text('$company$location', style: style,);
  }

  Widget _buildBackground(ThemeData theme, Widget child) {
    return Stack(
      children: <Widget>[
        Container(
          height: isSlef ? 160 : 180,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(user.avatarUrl),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 0),
            child: Container(
              color: theme.primaryColor.withOpacity(0.5),
            ),
          ),
        ),
        child
      ],
    );
  }

  Widget _buildToolTip(ThemeData theme, IconData icon, String urlPrefix,
      String url, String message) {
    if (url == null || url.isEmpty) {
      return Container();
    }
    return InkWell(
      onTap: () => _lauchUrl('$urlPrefix$url'),
      child: Tooltip(
        message: message,
        child: Icon(
          icon,
          size: 18.0,
          color: Colors.white,
        ),
      ),
    );
  }

  void _lauchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
