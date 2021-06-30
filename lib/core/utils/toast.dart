import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

const DEFAULT_TOAST_DURATION = Duration(seconds: 2);
const DEFAULT_TOAST_COLOR = Color(0xFF424242);

class ToastUtils {
  ToastUtils._internal();

  ///全局初始化Toast配置, child为MaterialApp
  static init(Widget child) {
    return OKToast(
      ///字体大小
      textStyle: TextStyle(fontSize: 16, color: Colors.white),
      backgroundColor: DEFAULT_TOAST_COLOR,
      radius: 10,
      dismissOtherOnShow: true,
      textPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: child,
      duration: DEFAULT_TOAST_DURATION,
    );
  }

  ///调用默认弹窗
  static void toast(String msg,
      {Duration duration = DEFAULT_TOAST_DURATION,
      Color color = DEFAULT_TOAST_COLOR}) {
    showToast(msg, duration: duration, backgroundColor: color);
  }

  ///调用等待样式弹窗
  static void waring(String msg, {Duration duration = DEFAULT_TOAST_DURATION}) {
    showToast(msg, duration: duration, backgroundColor: Colors.yellow);
  }

  ///调用错误样式弹窗
  static void error(String msg, {Duration duration = DEFAULT_TOAST_DURATION}) {
    showToast(msg, duration: duration, backgroundColor: Colors.red);
  }

  ///调用成功样式弹窗
  static void success(String msg,
      {Duration duration = DEFAULT_TOAST_DURATION}) {
    showToast(msg, duration: duration, backgroundColor: Colors.lightGreen);
  }
}
