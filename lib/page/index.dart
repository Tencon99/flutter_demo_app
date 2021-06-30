import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:unicorn_app/core/utils/click.dart';
import 'package:unicorn_app/core/utils/privacy.dart';
import 'package:unicorn_app/core/utils/toast.dart';
import 'package:unicorn_app/core/utils/utils.dart';
import 'package:unicorn_app/core/utils/xupdate.dart';
import 'package:unicorn_app/generated/i18n.dart';
import 'package:unicorn_app/page/home/tab_home.dart';
import 'package:unicorn_app/page/menu/sponsor.dart';
import 'package:unicorn_app/utils/provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'menu/menu_drawer.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key key}) : super(key: key);

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  List<BottomNavigationBarItem> getTabs(BuildContext context) => [
        BottomNavigationBarItem(
            label: I18n.of(context).home, icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            label: I18n.of(context).category, icon: Icon(Icons.list)),
        BottomNavigationBarItem(
            label: I18n.of(context).activity, icon: Icon(Icons.local_activity)),
        BottomNavigationBarItem(
            label: I18n.of(context).message, icon: Icon(Icons.notifications)),
        BottomNavigationBarItem(
            label: I18n.of(context).profile, icon: Icon(Icons.person)),
      ];

  ///显示操作菜单弹窗
  void showMenuDialog(String url, String linkUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          titlePadding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
          title: Text('操作'),
          children: <Widget>[
            linkUrl.isNotEmpty
                ? SimpleDialogOption(
                    child: Text('打开应用'),
                    onPressed: () {
                      Utils.launchURL(linkUrl);
                      Navigator.of(context).pop();
                    },
                  )
                : SizedBox(),
            SimpleDialogOption(
              child: Text('保存到本地'),
              onPressed: () {
                saveImage(url);
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('分享给好友'),
              onPressed: () {
                shareImage(url);
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text('修改图片'),
              onPressed: () {
                setImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///保存网络图片
  void saveImage(String url) {
    Permission.storage.request().then((value) {
      if (PermissionStatus.granted == value) {
        saveNetworkImageToPhoto(url).then((value) {
          if (value != null && value.isNotEmpty) {
            ToastUtils.success("图片保存成功: $value");
          } else {
            ToastUtils.error("图片保存失败!");
          }
        }).catchError((onError) {
          ToastUtils.error("图片保存失败:$onError");
        });
      } else {
        ToastUtils.error("权限申请失败!");
      }
    });
  }

  Future<String> saveNetworkImageToPhoto(String url,
      {bool useCache: true}) async {
    var data = await getNetworkImageData(url, useCache: useCache);
    return await ImagePickerSaver.saveFile(fileData: data);
  }

  void shareImage(String url) {
    Share.share(url);
  }

  void setImage() {
    UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);
    setState(() {
      userProfile.avatarUrl == 'http://112.124.99.196:8888/down/NufGheSSGGzk'
          ? userProfile.avatarUrl =
              'http://112.124.99.196:8888/down/KKpvRJvcS0B4'
          : userProfile.avatarUrl =
              'http://112.124.99.196:8888/down/NufGheSSGGzk';
    });
    Navigator.pop(context);
    ToastUtils.success('图片修改成功!');
  }

  List<Widget> getTabWidget(BuildContext context) => [
        // 主页
        TabHomePage(),
        // 分类
        Center(child: Text(I18n.of(context).category)),
        // 活动
        Center(
            child: Text(
          I18n.of(context).activity,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )),
        // 消息
        Container(
          child: Center(
              child: Text(
            I18n.of(context).message,
            style: TextStyle(color: Colors.white),
          )),
          color: Theme.of(context).primaryColor,
        ),
        // 我的
        Consumer2<UserProfile, AppInfo>(builder: (BuildContext context,
            UserProfile value, AppInfo appInfo, Widget child) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ClipOval(
                          child: value.avatarUrl != null
                              ? Image.network(
                                  value.avatarUrl,
                                  height: 100,
                                )
                              : FlutterLogo(
                                  size: 100,
                                ),
                        ),
                      ),
                      onTap: () {
                        // return ExtendedImage();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            // Color bgColor = Color.;
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                onLongPress: () {
                                  // ToastUtils.toast('长按了图片！');
                                  showMenuDialog(
                                      value.avatarUrl, value.avatarUrl);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: ExtendedImageSlidePage(
                                    slidePageBackgroundHandler: (offset, size) {
                                      double opacity = 0.0;
                                      opacity = offset.distance /
                                          (Offset(size.width, size.height)
                                                  .distance /
                                              2.0);
                                      return Colors.transparent.withOpacity(
                                          min(1.0, max(1.0 - opacity, 0.0)));
                                    },
                                    child: ExtendedImage(
                                      image: NetworkImage(value.avatarUrl),
                                      enableSlideOutPage: true,
                                      onDoubleTap:
                                          (ExtendedImageGestureState state) {},
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
                        // ToastUtils.waring('点击头像');
                      },
                    ),
                    Text(
                      I18n.of(context).profile + ' - 克莱因蓝',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 47, 167, 1.0),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '当前设备平台系统为 ${appInfo.platformIndex == 0 ? '安卓' : '苹果'}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            color: Colors.white,
          );
        }),
      ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    XUpdate.initAndCheck();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tabs = getTabs(context);
    return Consumer(
        builder: (BuildContext context, AppStatus status, Widget child) {
      return WillPopScope(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(tabs[status.tabIndex].label),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.security),
                    onPressed: () {
                      PrivacyUtils.showPrivacyDialog(context,
                          onAgressCallback: () {
                        Navigator.of(context).pop();
                        ToastUtils.success(I18n.of(context).agreePrivacy);
                      });
                    }),
                PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: "sponsor",
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              leading: Icon(
                                Icons.attach_money,
                              ),
                              title: Text(I18n.of(context).sponsor),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "settings",
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              leading: Icon(
                                Icons.settings,
                              ),
                              title: Text(I18n.of(context).settings),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "about",
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              leading: Icon(
                                Icons.error_outline,
                              ),
                              title: Text(I18n.of(context).about),
                            ),
                          ),
                        ],
                    onSelected: (String action) {
                      Get.toNamed('/menu/$action-page');
                    })
              ],
            ),
            drawer: MenuDrawer(),
            body: IndexedStack(
              index: status.tabIndex,
              children: getTabWidget(context),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: tabs,
              //高亮  被点击高亮
              currentIndex: status.tabIndex,
              //修改 页面
              onTap: (index) {
                status.tabIndex = index;
              },
              type: BottomNavigationBarType.fixed,
              fixedColor: Theme.of(context).primaryColor,
            ),
          ),
          //监听导航栏返回,类似onKeyEvent
          onWillPop: () =>
              ClickUtils.exitBy2Click(status: _scaffoldKey.currentState));
    });
  }
}
