/* Created by Sahil Bharti on 13/4/19.
 *
*/
import 'dart:io';


import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../exceptions/no_internet.dart';
import '../persistence/app_constants.dart';


class NetworkUtil {
 late Dio _dio;

  NetworkUtil() {
    BaseOptions options =
    BaseOptions(receiveTimeout: 1000000, connectTimeout: 1000000);
    options.baseUrl = AppConstants.BASE_URL;
    _dio = Dio(options);
    _dio.interceptors.add(LogInterceptor());
  }

  ///used for calling Get Request
  Future<Response?> get(String url, Map<String, String> params) async {
    bool isinternt = await checkInternet() ;
    if (isinternt){
     try{ Response response = await _dio.get(url,
          queryParameters: params,
          options: Options(responseType: ResponseType.json));
     debugPrint('network utils request: ${_dio.request(url).toString()}');
     debugPrint(' network utils get: ${response.toString()}');
      return response;}

     on DioError catch (e) {
       if(e.response != null){

         return e.response;
       }else{
         throw Exception(e.toString());

       }
     }
    }
    else {
      throw NoInternetException("Check the internet connectivity and try again.");
    }

  }


  ///used for calling post Request

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }



}
final networkUtil = NetworkUtil();

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
