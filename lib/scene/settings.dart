import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:rc/app_state.dart';
import 'package:rc/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:package_info/package_info.dart';

class SettingsScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScene> {


  @override
  Widget build(BuildContext context) {
    final AppState appState = Provide.value<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.important_devices),
            title: Text('暗黑模式'),
            trailing: Switch(
                value: appState.darkMode,
                onChanged: (value) {
                  SharedPreferences.getInstance().then((sp) {
                    sp.setBool(SETTINGS_DARK_MODE, value);
                    appState.darkMode = value;
                  });
                }),
          ),
          ListTile(
            leading: Icon(Icons.text_format),
            title: Text('字体大小'),
            trailing: PopupMenuButton(itemBuilder: (BuildContext context) {

              return [
                PopupMenuItem(
                  value: 1.0,
                  child: Text('默认'),
                ),
                PopupMenuItem(
                  value: 0.8,
                  child: Text('小'),
                ),
                PopupMenuItem(
                  value: 1.0,
                  child: Text('标准'),
                ),
                PopupMenuItem(
                  value: 1.05,
                  child: Text('大'),
                ),
                PopupMenuItem(
                  value: 1.10,
                  child: Text('巨大'),
                ),
              ];
            }, icon: Icon(Icons.arrow_drop_down),onSelected: (value)=>_setFontSize(context, value),),
          )
          ,
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text('问题反馈'),
            onTap: () {
              launch('mailto:tanhui2333@outlook.com?subject=[问题反馈]&body=');
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('分享'),
            onTap: () {
              https: //blog.csdn.net/u011272795/article/details/84989407
              FlutterShareMe().shareToSystem(msg: 'Rcer这个APP不错哦，欢迎使用^_^');
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('关于'),
            onTap: _showAboutDialog,
          ),
          appState.isLogin
              ? FlatButton(
                  color: Theme.of(context).cardColor,
                  child: Text(
                    '退出登录',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  onPressed: () {
                    _logout(context);
                  },
                )
              : Container()
        ],
      ),
    );
  }

  void _showAboutDialog() {

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      showAboutDialog(
          context: context,
          applicationName: appName,
          applicationVersion: '${version}_$buildNumber',
          applicationIcon: SizedBox(
            width: 50,
            height: 50,
            child: Image.asset('images/logo.png'),
          ),
          children: [
            Text('ruby-china.org第三方客户端'),
          ]);

    });

  }


  void _setFontSize(BuildContext context, double size) async {
    final AppState appState = Provide.value<AppState>(context);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool success = await sp.setDouble(SETTINGS_FONT_SIZE, size);
    if (success) {
      appState.fontSize = size;
    }
  }


  void _logout(BuildContext context) async {
    final AppState appState = Provide.value<AppState>(context);
    final SharedPreferences sp = await SharedPreferences.getInstance();
    bool success = await sp.remove(SP_KEY_TOKEN);
    if (success) {
      appState.isLogin = false;
    }
  }
}
