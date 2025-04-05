import 'package:dio/dio.dart';

class WeatherApi {
  final Dio dio = Dio();
  static const String root = "https://geoapi.qweather.com";
  static const String root2 = "https://devapi.qweather.com";
  static const String key = "94abf59b11b24ea8b93e9cadf05ba661";

  Future<Map<String, dynamic>> getWeather(String location) async {
    const String url = '$root2/v7/weather/now';
    try {
      final response = await dio
          .get(url, queryParameters: {'location': location, 'key': key});
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<List> searchCity(String location) async {
    const String url = '$root/v2/city/lookup';
    try {
      final response = await dio
          .get(url, queryParameters: {'location': location, 'key': key});
      if (response.statusCode == 200) {
        return response.data['location'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List> futurethree(String location) async {
    const String url = '$root2/v7/weather/3d';
    try {
      final response = await dio
          .get(url, queryParameters: {'location': location, 'key': key});
      if (response.statusCode == 200) {
        return response.data['daily'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List> futureseven(String location) async {
    const String url = '$root2/v7/weather/7d';
    try {
      final response = await dio
          .get(url, queryParameters: {'location': location, 'key': key});
      if (response.statusCode == 200) {
        return response.data['daily'];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
