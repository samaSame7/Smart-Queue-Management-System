import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../ui/widgets/faq_dm.dart';

class FaqApiService {
  final String baseUrl;
  final http.Client _client;

  final Future<String?> Function()? tokenProvider;

  FaqApiService({
    String? baseUrl,
    http.Client? client,
    this.tokenProvider,
  })  : baseUrl = baseUrl ?? AppConfig.publicApiBaseUrl,
        _client = client ?? http.Client();

  Future<List<FaqDm>> fetchFaqs({
    String search = '',
    int limit = 200,
    int skip = 0,
  }) async {
    final uri = Uri.parse('$baseUrl/faqs').replace(
      queryParameters: <String, String>{
        if (search.trim().isNotEmpty) 'search': search.trim(),
        'limit': '$limit',
        'skip': '$skip',
      },
    );

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    final token = tokenProvider == null ? null : await tokenProvider!();
    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    final res = await _client.get(uri, headers: headers);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('FAQ request failed: ${res.statusCode} ${res.body}');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected response format (not a JSON object)');
    }

    final data = decoded['data'];
    if (data is! List) {
      throw Exception('Unexpected response format: missing "data" array');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(_mapJsonToFaqDm)
        .toList(growable: false);
  }

  FaqDm _mapJsonToFaqDm(Map<String, dynamic> json) {
    return FaqDm(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['question'] ?? '').toString(),
      content: (json['answer'] ?? '').toString(),
    );
  }
}
