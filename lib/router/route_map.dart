import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:tencon_flutter_app/init/splash.dart';
import 'package:tencon_flutter_app/page/index.dart';
import 'package:tencon_flutter_app/page/menu/about.dart';
import 'package:tencon_flutter_app/page/menu/language.dart';
import 'package:tencon_flutter_app/page/menu/login.dart';
import 'package:tencon_flutter_app/page/menu/register.dart';
import 'package:tencon_flutter_app/page/menu/settings.dart';
import 'package:tencon_flutter_app/page/menu/sponsor.dart';
import 'package:tencon_flutter_app/page/menu/theme_color.dart';
import 'package:tencon_flutter_app/router/route_map.gr.dart';
import 'package:tencon_flutter_app/utils/sputils.dart';

///页面路由映射表
@CustomAutoRouter(
    routes: <AutoRoute>[
      AutoRoute(page: SplashPage, initial: true),
      AutoRoute(page: MainHomePage, guards: [AuthGuard]),
      CustomRoute(page: SponsorPage, path: '/menu/sponsor-page'),
      CustomRoute(page: SettingsPage, path: '/menu/settings-page'),
      CustomRoute(page: AboutPage, path: '/menu/about-page'),
      AutoRoute(page: LoginPage),
      AutoRoute(page: RegisterPage),
      AutoRoute(page: ThemeColorPage),
      AutoRoute(page: LanguagePage)
    ],
    routesClassName: 'Routes',
    transitionsBuilder: getTransitions,
    durationInMilliseconds: 800)
class $RouterMap {}

/// 认证处理
class AuthGuard extends RouteGuard {
  Future<bool> canNavigate(ExtendedNavigatorState navigator, String routeName,
      Object arguments) async {
    if (SPUtils.isLogined()) {
      return true;
    }
    navigator.replace(Routes.loginPage);
    return false;
  }
}

/// 页面切换动画
Widget getTransitions(BuildContext context, Animation<double> animation1,
    Animation<double> animation2, Widget child) {
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
