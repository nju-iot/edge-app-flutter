import 'package:dio/dio.dart';

//封装请求
class MyHttp{
  MyHttp._internal();


  //使用Dio来处理网络请求
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl:"http://106.14.157.113:6789",
      connectTimeout:5000,
      receiveTimeout:3000,
    )
  );

  ///初始化dio
  static init(){



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

  //封装get
  static Future get(String url,[Map<String,dynamic> params]) async {
    Response response;
    if(params != null){
      response = await dio.get(url,queryParameters: params);
    } else {
      response = await dio.get(url);
    }
    return response.data;
  }

  //post 表单请求
  static Future post(String url,[Map<String,dynamic> params]) async {
    Response response = await dio.post(url,queryParameters: params);
    return response.data;
  }

  //post body请求
  static Future postJson(String url, [Map<String, dynamic> data]) async {
    Response response = await dio.post(url, data: data);
    return response.data;
  }


  //put请求
  static Future putJson(String url,[Map<String,dynamic> data]) async{
    Response response = await dio.put(url,data:data);
    return response.data;
  }

  //delete请求
  static Future delete(String url) async{
    Response response = await dio.delete(url);
    return response.data;
  }


}