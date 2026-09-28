import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/wine.dart';
import '../models/winery.dart';

/// Клиент для связи с бэкендом.
class ApiClient {
  ApiClient({this.baseUrl = 'http://localhost:8080/api', http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<List<Wine>> fetchWines() async {
    final data = await _getList('/wines');
    return data.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Winery>> fetchWineries() async {
    final data = await _getList('/wineries');
    return data.map((e) => Winery.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<dynamic>> _getList(String path) async {
    final response = await _client.get(Uri.parse('$baseUrl$path'));
    if (response.statusCode != 200) {
      throw Exception('GET $path failed: ${response.statusCode}');
    }
    return jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
  }
}
