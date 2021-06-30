import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_app/core/utils/toast.dart';
import 'package:unicorn_app/core/utils/xuifont.dart';
import 'package:unicorn_app/generated/i18n.dart';
import 'package:unicorn_app/page/menu/about.dart';
import 'package:unicorn_app/page/menu/login.dart';
import 'package:unicorn_app/page/menu/settings.dart';
import 'package:unicorn_app/page/menu/sponsor.dart';
import 'package:unicorn_app/utils/provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProfile, AppStatus>(builder: (BuildContext context,
        UserProfile value, AppStatus status, Widget child) {
      return Drawer(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.only(top: 50, bottom: 20),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipOval(
                        // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                        child: value.avatarUrl != null
                            ? Image.network(
                                value.avatarUrl,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : FlutterLogo(
                                size: 80,
                              ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      value.nickName != null
                          ? value.nickName
                          : I18n.of(context).title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ))
                  ],
                ),
              ),
              onTap: () {
                // ToastUtils.toast("点击头像");
                // ExtendedImage.network(url)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    // Color bgColor = Color.;
                    return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: ExtendedImageSlidePage(
                            slidePageBackgroundHandler: (offset, size) {
                              double opacity = 0.0;
                              opacity = offset.distance /
                                  (Offset(size.width, size.height).distance /
                                      2.0);
                              return Colors.transparent.withOpacity(
                                  min(1.0, max(1.0 - opacity, 0.0)));
                            },
                            child: ExtendedImage(
                              image: NetworkImage(value.avatarUrl),
                              enableSlideOutPage: true,
                              onDoubleTap: (ExtendedImageGestureState state) {},
                              // heroBuilderForSlidingPage:
                              // color: Color.fromRGBO(0, 47, 167, 1.0),
                            ),
                            slideAxis: SlideAxis.both,
                            slideType: SlideType.onlyImage,
                            onSlidingPage: (state) {
                              // 滑动页面的回调，你可以在这里改变页面上其他元素的状态
                              print('滑动页面！');
                            },
                          ),
                        ));
                  }),
                  // Transparent
                );
              },
            ),
            MediaQuery.removePadding(
              context: context,
              // DrawerHeader consumes top MediaQuery padding.
              removeTop: true,
              child: ListView(
                shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                physics: NeverScrollableScrollPhysics(), //禁用滑动事件
                scrollDirection: Axis.vertical, // 水平listView
                children: <Widget>[
                  //首页
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text(I18n.of(context).home),
                    onTap: () {
                      status.tabIndex = TAB_HOME_INDEX;
                      Navigator.pop(context);
                    },
                    selected: status.tabIndex == TAB_HOME_INDEX,
                  ),
                  ListTile(
                    leading: Icon(Icons.list),
                    title: Text(I18n.of(context).category),
                    onTap: () {
                      status.tabIndex = TAB_CATEGORY_INDEX;
                      Navigator.pop(context);
                    },
                    selected: status.tabIndex == TAB_CATEGORY_INDEX,
                  ),
                  ListTile(
                    leading: Icon(Icons.local_activity),
                    title: Text(I18n.of(context).activity),
                    onTap: () {
                      status.tabIndex = TAB_ACTIVITY_INDEX;
                      Navigator.pop(context);
                    },
                    selected: status.tabIndex == TAB_ACTIVITY_INDEX,
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(I18n.of(context).message),
                    onTap: () {
                      status.tabIndex = TAB_MESSAGE_INDEX;
                      Navigator.pop(context);
                    },
                    selected: status.tabIndex == TAB_MESSAGE_INDEX,
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(I18n.of(context).profile),
                    onTap: () {
                      status.tabIndex = TAB_PROFILE_INDEX;
                      Navigator.pop(context);
                    },
                    selected: status.tabIndex == TAB_PROFILE_INDEX,
                  ),
                  //设置、关于、赞助
                  Divider(height: 1.0, color: Colors.grey),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text(I18n.of(context).sponsor),
                    onTap: () {
                      Get.to(() => SponsorPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(I18n.of(context).settings),
                    onTap: () {
                      Get.to(() => SettingsPage());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.error_outline),
                    title: Text(I18n.of(context).about),
                    onTap: () {
                      Get.to(() => AboutPage());
                    },
                  ),
                  //退出
                  Divider(height: 1.0, color: Colors.grey),
                  ListTile(
                    leading: Icon(XUIIcons.logout),
                    title: Text(I18n.of(context).logout),
                    onTap: () {
                      value.nickName = "";
                      value.avatarUrl = "";
                      Get.offAll(() => LoginPage());
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ));
    });
  }
}
