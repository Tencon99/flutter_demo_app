import 'package:get/get.dart';

class XRouter {
  /// go to webview页面 --- 参数`[url 地址] [title 标题]`
  static void goWeb(String url, String title) {
    Get.toNamed(
        "/web?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}");
  }
}
