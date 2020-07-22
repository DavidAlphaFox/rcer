//library dependency_injector;
//
//import 'package:flutter/widgets.dart';
//
//import 'package:rc/repository/rc_repo.dart';
//
//class Injector extends InheritedWidget {
//  final OauthRepository oauthRepository;
//  final UserRepository userRepository;
//  final RCRepo rcRepo;
//
//  Injector(
//      {Key key,
//      @required this.oauthRepository,
//      @required this.userRepository,
//        @required this.rcRepo,
//      @required Widget child})
//      : super(key: key, child: child);
//
//  static Injector of(BuildContext context) =>
//      context.inheritFromWidgetOfExactType(Injector);
//
//  @override
//  bool updateShouldNotify(Injector oldWidget) =>
//      oauthRepository != oldWidget.oauthRepository ||
//      userRepository != oldWidget.userRepository ||
//      rcRepo != oldWidget.rcRepo;
//}
