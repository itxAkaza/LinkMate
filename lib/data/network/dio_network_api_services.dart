
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';


import '../exceptions/dio_Exception.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {


  final  _dio=Dio();





  @override
  Future<dynamic> getApi(String url)async
  {

    if(kDebugMode){ // for check api hit
      print(url);
    }
    dynamic responseJson;

    try{

      final response=await _dio.get(url).timeout(Duration(seconds: 10));
      responseJson=returnResponse(response);

    }
    on DioException catch (e)
    {
      if (e.error is SocketException)
      {
        throw InternetException("");
      }
      else if (e.type == DioExceptionType.connectionTimeout)
      {
        throw RequestTimeOut("");
      }
    }
    return responseJson;


  }



  @override
  Future<dynamic> postApi(var data,String url)async
  {

    if(kDebugMode){
      print(url);
      print(data);
    }
    dynamic responseJson;

    try{

      final response=await _dio.post(url,
          data: data, //<-if in raw form. if no then simple data
          options: Options(
              headers: {
                "x-api-key":"reqres-free-v1"
              }
          )
      ).timeout(Duration(seconds: 10));

      responseJson=returnResponse(response);

    } on DioException catch (e)
    {
      if (e.error is SocketException)
      {
        throw InternetException("");
      }
      else if (e.type == DioExceptionType.connectionTimeout)
      {
        throw RequestTimeOut("");
      }
    }

    return responseJson;


  }



  Future<dynamic> putApi(var data, String url) async {

    if (kDebugMode) {
      print(url);
      print(data);
    }
    dynamic responseJson;

    try {
      final response = await _dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            "x-api-key": "reqres-free-v1",
          },
        ),
      ).timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);

    }  on DioException catch (e)
    {
      if (e.error is SocketException)
      {
        throw InternetException("");
      }
      else if (e.type == DioExceptionType.connectionTimeout)
      {
        throw RequestTimeOut("");
      }
    }

    return responseJson;



  }


  Future<dynamic> deleteApi(String url) async {

    if (kDebugMode) {
      print(url);
    }

    dynamic responseJson;

    try {

      final response = await _dio.delete(
        url,
        options: Options(
          headers: {
            "x-api-key": "reqres-free-v1",
          },
        ),
      ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);

    } on DioException catch (e)
    {
      if (e.error is SocketException)
      {
        throw InternetException("");
      }
      else if (e.type == DioExceptionType.connectionTimeout)
      {
        throw RequestTimeOut("");
      }
    }

    return responseJson;


  }



  Future<dynamic> uploadFile(String url, String filePath, {Map<String, dynamic>? additionalData}) async {

    if (kDebugMode) {
      print(url);
      print("Uploading: $filePath");
    }

    dynamic responseJson;

    try {

      final formData = FormData.fromMap({
        ...?additionalData,
        'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),

      });

      final response = await _dio.post(
        url,
        data: formData,
      ).timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);

    }  on DioException catch (e)
    {
      if (e.error is SocketException)
      {
        throw InternetException("");
      }
      else if (e.type == DioExceptionType.connectionTimeout)
      {
        throw RequestTimeOut("");
      }
    }

    return responseJson;


  }



  Future<void> downloadFile(String url, String savePath, {Function(int, int)? onProgress}) async {

    if (kDebugMode) {
      print("Downloading: $url");
    }

    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onProgress,
      );

    }  on DioException catch (e)
    {
      if (e.error is SocketException)
      {
        throw InternetException("");
      }
      else if (e.type == DioExceptionType.connectionTimeout)
      {
        throw RequestTimeOut("");
      }
    }
  }



  dynamic returnResponse(Response response) {

    switch (response.statusCode)
    {
      case 200:
        return response.data;
      case 400:
        throw InvalidUrlException("400 ");
      case 401:
        throw UnauthorisedException("401 ");
      case 403:
        throw ForbiddenException("403 ");
      case 404:
        throw NotFoundException("404 ");
      case 500:
        throw ServerException("500 ");
      case 503:
        throw ServiceUnavailableException("503 ");
      default:
        throw FetchDataException("Error while communicating with server ${response.statusCode.toString()}");
    }


  }




}








//
// class ApiService {
//   final Dio _dio = Dio(
//     BaseOptions(
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         // Add auth token if needed
//         // 'Authorization': 'Bearer your_token_here',
//       },
//     ),
//   );
//
//   // Simple GET request
//   Future<dynamic> getRequest(String url) async {
//     try {
//       final response = await _dio.get(url);
//       return response.data;
//     } on DioError catch (e) {
//       _handleDioError(e);
//     }
//   }
//
//   // POST request
//   Future<dynamic> postRequest(String url, Map<String, dynamic> data) async {
//     try {
//       final response = await _dio.post(url, data: data);
//       return response.data;
//     } on DioError catch (e) {
//       _handleDioError(e);
//     }
//   }
//
//   // File download with progress
//   Future<void> downloadFile(String url, String savePath, {Function(int, int)? onProgress}) async {
//     try {
//       await _dio.download(
//         url,
//         savePath,
//         onReceiveProgress: onProgress,
//       );
//     } on DioError catch (e) {
//       _handleDioError(e);
//     }
//   }
//
//   // File upload
//   Future<dynamic> uploadFile(String url, String filePath, {Map<String, dynamic>? additionalData}) async {
//     try {
//       final formData = FormData.fromMap({
//         ...?additionalData,
//         'file': await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
//       });
//
//       final response = await _dio.post(url, data: formData);
//       return response.data;
//     } on DioError catch (e) {
//       _handleDioError(e);
//     }
//   }
//
//   // Central error handler
//   void _handleDioError(DioError e) {
//     if (e.type == DioErrorType.connectionTimeout ||
//         e.type == DioErrorType.receiveTimeout) {
//       throw Exception("Connection timeout. Please try again.");
//     } else if (e.type == DioErrorType.connectionError) {
//       throw Exception("No Internet connection.");
//     } else if (e.type == DioErrorType.badResponse) {
//       int? code = e.response?.statusCode;
//       String message = e.response?.statusMessage ?? "Something went wrong";
//       throw Exception("Error $code: $message");
//     } else {
//       throw Exception("Unexpected error occurred.");
//     }
//   }
// }
