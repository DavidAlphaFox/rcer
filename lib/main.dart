import 'dart:io';

import 'package:flutter/material.dart';
import 'home.dart';
import 'package:flutter/services.dart';
import 'package:provide/provide.dart';
import 'app_state.dart';
import 'scene/user_login_scene.dart';
import 'routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:rc/scene/settings.dart';
import 'package:rc/scene/add_topic_scene.dart';
import 'package:event_bus/event_bus.dart';
import 'event/events.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  var providers = Providers()..provide(Provider.function((ctx) => AppState()));

  runApp(ProviderNode(child: RCApp(), providers: providers));

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    //https://www.jianshu.com/p/97e93c82ccef
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

final ThemeData defaultThemeData = ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light);
final ThemeData darkThemeData = ThemeData( brightness: Brightness.dark, accentColor: Colors.redAccent);

class RCApp extends StatelessWidget {

  final EventBus _eventBus = EventBusManager.instance.eventBus;
  @override
  Widget build(BuildContext context) {

    timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());

    final AppState appState = Provide.value<AppState>(context);

    _eventBus.on<RefreshTokenFailEvent>().listen((event) {
      _clearLoginInfo(appState);
    });

    _loadSystemInfo(appState);


    return StreamBuilder<AppState>(
      initialData: appState,
      stream: Provide.stream<AppState>(context),
      builder: (context, snapshot) => MaterialApp(
        builder: (context, child){
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: appState.fontSize),
            child: child,
          );
        },
        theme: appState.darkMode ? darkThemeData : defaultThemeData,
        initialRoute: RCRoutes.home,
        routes: {
          RCRoutes.home: (context) {
            return AppHomeScene();
          },
          RCRoutes.login: (context) {
            return UserLoginScene();
          },
          RCRoutes.settings: (context) {
            return Provide<AppState>(
              builder: (context, child, appState) => SettingsScene(),
            );
          },
          RCRoutes.addEditTopic: (context) {
            return AddTopicScene();
          }
        }),
    );
  }

  void _loadSystemInfo(AppState appState) async {
    final SharedPreferences sp = await  SharedPreferences.getInstance();

    bool isLogin = sp.get(SP_KEY_TOKEN) != null;

    bool darkMode = sp.getBool(SETTINGS_DARK_MODE);
    double fontSize = sp.getDouble(SETTINGS_FONT_SIZE);

    appState.init(isLogin, darkMode == null ? false : darkMode, fontSize);
  }

  void _clearLoginInfo(AppState appState) async {
    final SharedPreferences sp = await  SharedPreferences.getInstance();
    sp.remove(SP_KEY_TOKEN).then((_){
      appState.isLogin = false;
    });
  }
}
