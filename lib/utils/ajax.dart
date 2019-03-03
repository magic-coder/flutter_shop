import 'package:dio/dio.dart';
import 'dart:io';

class Http {
  static Http instance;
  static String token;
  static Dio _dio;
  BaseOptions _options;

  static Http getInstance() {
    if (instance == null) {
      instance = new Http();
    }
    return instance;
  }

  Http() {
    // 初始化 Options
    _options = BaseOptions(
        baseUrl: 'https://www.easy-mock.com/mock/',
        connectTimeout: 10000,
        receiveTimeout: 10000,
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        headers: {});

    _dio = new Dio(_options);

    _dio.interceptors.add(InterceptorsWrapper(
        onRequest:(RequestOptions options){
          // 在请求被发送之前做一些事情
          return options; //continue
          // 如果你想完成请求并返回一些自定义数据，可以返回一个`Response`对象或返回`dio.resolve(data)`。
          // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义数据data.
          //
          // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象，或返回`dio.reject(errMsg)`，
          // 这样请求将被中止并触发异常，上层catchError会被调用。
        },
        onResponse:(Response response) {
          // 在返回响应数据之前做一些预处理
          return response; // continue
        },
        onError: (DioError e) {
          // 当请求失败时做一些预处理
          return e;//continue
        }
    ));

    _dio.interceptors.add(LogInterceptor(responseBody: false));
  }

  // get 请求封装
  get(url, {options, cancelToken, queryParameters}) async {
    Response response;
    try {
      response =
          await _dio.get(url, queryParameters: queryParameters, cancelToken: cancelToken);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get请求取消! ' + e.message);
      } else {
        print('get请求发生错误：$e');
        return null;
      }
    }
    return response.data;
  }

  // post请求封装
  post(url, {options, cancelToken, data}) async {
    Response response;

    try {
      response = await _dio.post(url,
          data: data != null ? data : {}, cancelToken: cancelToken);
      print(response);
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('post请求取消! ' + e.message);
      } else {
        print('post请求发生错误：$e');
      }
    }
    return response.data;
  }
}
