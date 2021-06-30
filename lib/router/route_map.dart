import 'package:flutter/material.dart';
import 'package:unicorn_app/core/widget/web_view_page.dart';
import 'package:unicorn_app/init/splash.dart';
import 'package:unicorn_app/page/index.dart';
import 'package:unicorn_app/page/menu/about.dart';
import 'package:unicorn_app/page/menu/login.dart';
import 'package:unicorn_app/page/menu/settings.dart';
import 'package:unicorn_app/page/menu/sponsor.dart';
import 'package:get/get.dart';

///路由Map配置
class RouteMap {
  /// 页面列表
  static List<GetPage> getPages = [
    GetPage(name: '/', page: () => SplashPage()),
    GetPage(name: '/login', page: () => LoginPage()),
    GetPage(name: '/home', page: () => MainHomePage()),
    GetPage(name: '/web', page: () => WebViewPage()),
    GetPage(name: '/menu/sponsor-page', page: () => SponsorPage()),
    GetPage(name: '/menu/settings-page', page: () => SettingsPage()),
    GetPage(name: '/menu/about-page', page: () => AboutPage()),
  ];

  /// 页面切换动画
  static Widget getTransitions(
      BuildContext context,
      Animation<double> animation1,
      Animation<double> animation2,
      Widget child) {
    /// 平移动画
    return SlideTransition(
      position: Tween<Offset>(
              //1.0为右进右出，-1.0为左进左出
              begin: Offset(1.0, 0.0),
              end: Offset(0.0, 0.0))
          .animate(
              CurvedAnimation(parent: animation1, curve: Curves.fastOutSlowIn)),
      child: child,
    );
  }
}
