import 'dart:collection';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencon_flutter_app/core/utils/path.dart';

// ignore: todo
// TODO 修改网络请求配置，包括：服务器地址、超时、拦截器等设置
class XHttp {
  XHttp._internal();

  ///网络请求配置
  static final Dio dio = Dio(BaseOptions(
    baseUrl: "http://cs.qqly.xyz/unicorn",
    connectTimeout: 5000,
    receiveTimeout: 3000,
  ));

  ///初始化dio
  static init() {
    ///初始化cookie
    PathUtils.getDocumentsDirPath().then((value) {
      var cookieJar = PersistCookieJar(dir: value + "/.cookies/");
      dio.interceptors.add(CookieManager(cookieJar));
    });

    //添加拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("请求之前");
      return options;
    }, onResponse: (Response response) {
      print("响应之前");
      return response;
    }, onError: (DioError e) {
      print("错误之前");
      handleError(e);
      return e;
    }));
  }

  ///error统一处理
  static void handleError(DioError e) {
    switch (e.type) {
      case DioErrorType.CONNECT_TIMEOUT:
        print("连接超时");
        break;
      case DioErrorType.SEND_TIMEOUT:
        print("请求超时");
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        print("响应超时");
        break;
      case DioErrorType.RESPONSE:
        print("出现异常");
        break;
      case DioErrorType.CANCEL:
        print("请求取消");
        break;
      default:
        print("未知错误");
        break;
    }
  }

  ///   `发起网络请求`
  ///
  ///   `[ url] 请求url`
  ///
  ///   `[ param] 请求参数`` [header] 外加头`
  ///
  ///
  ///   `[ isNeedToken] 是否需要token`
  ///
  ///   `[ optionMethod] 请求类型 post、get`
  ///
  ///   `[ noTip] 是否需要返回错误信息 默认不需要`
  ///
  ///   `[ needSign] 是否需要Sign校验  默认需要`
  ///
  ///   `[ needError] 是否需要错误提示`
  static Future request(
    url,
    param, {
    Map<String, dynamic> header,
    bool isNeedToken = true,
    String optionMethod = "get",
    noTip = false,
    needSign = true,
    needError = true,
  }) async {
    /// Options单次请求配置
    Options option = new Options(method: optionMethod);
    BuildContext context;

    ///头部
    Map<String, dynamic> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }

    /// 获取token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.get('userToken');
    if (userToken != null) {
      // print("usetTOken:" + userToken);
      Map<String, String> auth = {"Authorization": "Bearer " + userToken};
      headers.addAll(auth);
    }
    option.headers = headers;
    //    if (needSign) {
    //      //获取加密的请求参数
    //      params = await SignConfig.signData(param, mirrorToken);
    //    }    var mirrorToken = "";

    var params = param;
    print("params:" + params.toString());
    print("params" + params.runtimeType.toString());
    // print(response.statusCode);
    // return response;
    Response response;
    try {
      print("请求地址：" + dio.options.baseUrl + url);
      response =
          // await dio.request("${dio.options.baseUrl}$url", data: params, options: option);
          // response =
          await dio.request("${dio.options.baseUrl}$url",
              data: params, options: option);
      print(response.statusCode);
      return response;
    } on DioError catch (errorResponse) {
      formatError(errorResponse, context);
      print("1.dio error response：" + errorResponse.toString());
      return errorResponse;
    }
  }

  ///get请求
  static Future get(String url, [Map<String, dynamic> params]) async {
    Response response;
    if (params != null) {
      response = await dio.get(url, queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    return response.data;
  }

  ///post 表单请求
  static Future post(String url, [Map<String, dynamic> params]) async {
    Response response = await dio.post(url, queryParameters: params);
    return response.data;
  }

  ///post body请求
  static Future postJson(String url, [Map<String, dynamic> data]) async {
    Response response = await dio.post(url, data: data);
    return response.data;
  }

  /*
  * error统一处理*/
  static void formatError(DioError e, BuildContext context) {
    print("format*******" + e.type.toString());
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      print("连接超时");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      print("请求超时");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      print("响应超时");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常");
      print("出现异常" + e.response.statusCode.toString());
      final int status = e.response.statusCode;
      switch (status) {
        case 400:
          break;
        case 500:
          print("服务器error:" + e.message);
          break;
        case 404:
          break;
        default:
          break;
      }
    } else if (e.type == DioErrorType.CANCEL) {
// When the request is cancelled, dio will throw a error with this type.
      print("请求取消");
    } else {
//DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误" + e.message);
    }
  }

  ///下载文件
  static Future downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        print("$count $total");
      });
    } on DioError catch (e) {
      handleError(e);
    }
    return response.data;
  }
}
