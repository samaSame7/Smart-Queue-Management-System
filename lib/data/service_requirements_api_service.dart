import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../core/config/end_points.dart';
import '../ui/widgets/faq_dm.dart';

class ServiceRequirementsApiService {
  final String baseUrl;
  final http.Client _client;

  final Future<String?> Function()? tokenProvider;

  ServiceRequirementsApiService({
    String? baseUrl,
    http.Client? client,
    this.tokenProvider,
  })  : baseUrl = baseUrl ?? AppConfig.publicApiBaseUrl,
        _client = client ?? http.Client();

  Future<List<FaqDm>> fetchServiceRequirements() async {
    final uri = Uri.parse('$baseUrl${Endpoints.services}');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    final token = tokenProvider == null ? null : await tokenProvider!();
    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    final res = await _client.get(uri, headers: headers);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Services request failed: ${res.statusCode} ${res.body}');
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
        .map(_mapServiceJsonToFaqDm)
        .toList(growable: false);
  }

  FaqDm _mapServiceJsonToFaqDm(Map<String, dynamic> json) {
    final idStr = (json['_id'] ?? json['id'] ?? '').toString();
    final name = (json['name'] ?? '').toString();
    final description = (json['description'] ?? json['desc'] ?? '').toString();

    final requirementsRaw = json['requirements'];
    final requirements = <String>[];
    if (requirementsRaw is List) {
      for (final r in requirementsRaw) {
        if (r == null) continue;
        requirements.add(r.toString());
      }
    }

    String content = "";
    if (description.isNotEmpty) {
      content += "$description\n\n";
    }

    if (requirements.isEmpty) {
      content += 'لا توجد متطلبات';
    } else {
      content += "المتطلبات:\n";
      content += requirements.map((e) => '- $e').join('\n');
    }

    return FaqDm(
      id: idStr,
      title: name,
      content: content.trim(),
    );
  }
}
