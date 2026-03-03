import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/coin.dart';

class ApiService {
  static const String _host = 'api.coingecko.com';

  Future<List<Coin>> fetchCoins() async {
    final uri = Uri.https(
      _host,
      '/api/v3/coins/markets',
      {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': '25',
        'page': '1',
        'sparkline': 'false',
        'price_change_percentage': '24h',

        // ✅ cache-buster: makes the URL unique every request
        '_': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );

    final client = http.Client();
    try {
      final response = await client
          .get(
            uri,
            headers: const {
              'accept': 'application/json',
              'user-agent': 'week6_api_app/1.0',

              // ✅ prevent caching
              'cache-control': 'no-cache',
              'pragma': 'no-cache',
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw HttpException(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw const FormatException('Unexpected JSON format (expected List)');
      }

      return decoded
          .cast<Map<String, dynamic>>()
          .map((j) => Coin.fromJson(j))
          .toList();
    } on SocketException {
      throw const SocketException('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } on FormatException catch (e) {
      throw FormatException('JSON parsing error: ${e.message}');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error: $e');
    } finally {
      client.close();
    }
  }
}