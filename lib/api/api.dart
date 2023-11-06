import 'package:dio/dio.dart';

const domain = 'https://vnpt-epay-demo.onrender.com';
final dio = Dio();

class Api {
  Future<dynamic> get(
    String path, {
    String domain = domain,
  }) async {
    String url = '$domain$path';

    final response = await dio.get(url,
        options: Options(headers: {'Content-Type': 'application/json'}));
    return response.data;
  }

  Future<dynamic> post(
    String path, {
    String domain = domain,
    required Map<String, dynamic> data,
  }) async {
    String url = '$domain$path';
    final response = await dio.post(url,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}));
    return response.data;
  }
}
