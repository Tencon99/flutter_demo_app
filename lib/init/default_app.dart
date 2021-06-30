import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:unicorn_app/core/http/http.dart';
import 'package:unicorn_app/core/utils/toast.dart';
import 'package:unicorn_app/generated/i18n.dart';
import 'package:unicorn_app/router/route_map.dart';
import 'package:unicorn_app/utils/provider.dart';
import 'package:unicorn_app/utils/sputils.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

//默认App的启动
class DefaultApp {
  //运行app
  static void run() {
    WidgetsFlutterBinding.ensureInitialized();
    // 初始化本地存储---SharedPreferences
    SPUtils.init().then(
      // 本地存储初始化后
      (value) => runApp(
        // 初始化数据共享---provider
        Store.init(
          // 初始化自定义的全局弹窗---toast
          ToastUtils.init(MyApp()),
        ),
      ),
    );
    initApp();
  }

  //程序初始化操作
  static void initApp() {
    // 网络请求初始化
    XHttp.init();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AppTheme, LocaleModel>(
        builder: (context, appTheme, localeModel, _) {
      return GetMaterialApp(
        /// APP unicorn（独角兽）
        /// anthor: Tencon99
        title: 'unicorn',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // 主要样式的主题配置 --- 从共享数据provider中获取主题颜色
          primarySwatch: appTheme.themeColor,
          // 按钮颜色的主题配置 --- 从共享数据provider中获取主题颜色
          buttonColor: appTheme.themeColor,
        ),
        // 获取页面
        getPages: RouteMap.getPages,
        // 默认动画 --- 右至左
        defaultTransition: Transition.rightToLeft,
        // 语言 --- 从共享数据provider中获取`语言`
        locale: localeModel.getLocale(),
        // 支持地区 --- 获取可选的语言地区列表
        supportedLocales: I18n.delegate.supportedLocales,
        // 本地化列表
        localizationsDelegates: [
          I18n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // 本地语言选择回调
        localeResolutionCallback:
            // supportedLocales为语言列表 ,如果没有选定语言，并且系统如果为空的化，取语言列表第一项
            (Locale _locale, Iterable<Locale> supportedLocales) {
          if (localeModel.getLocale() != null) {
            //如果已经选定语言，则不跟随系统
            return localeModel.getLocale();
          } else {
            //跟随系统
            if (I18n.delegate.isSupported(_locale)) {
              return _locale;
            }
            return supportedLocales.first;
          }
        },
      );
    });
  }
}
