import 'package:dio/dio.dart';

class DioOption {
  late Dio client;

  Dio createDio({String? baseUrl}) {
    // if (baseUrl != null) {
    //   print('Bearer ${Globals().token}');
    // }
    //print('url-' + baseUrl.toString());
    client = Dio();
    //client.options.connectTimeout = 10000 as Duration?;
    client.options.baseUrl = 'http://192.168.100.244:3000/api';
    client.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers.addAll({'Accept': 'application/json'});
      options.headers.addAll({'content-type': 'application/json'});
      //options.headers.addAll({'Authorization': 'Bearer ${Globals().token}'});
      return handler.next(options);
    }, onResponse: (response, handler) async {
      // Do something with response data
      // return response; // continue
      return handler.next(response);
    }));
    return client;
  }
}
