import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validator/domain/entities/token.dart';
import 'package:validator/infrastructure/utilities/public_endpoints.dart';

class TokenInterceptor extends http.BaseClient {
  final http.Client client;

  TokenInterceptor({required this.client});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!_requiresTokenAuthentication(request.url.toString())) {
      final sharedPreferences = GetIt.instance<SharedPreferences>();
      if (sharedPreferences.containsKey('token')) {
        final String? strToken = sharedPreferences.getString('token');
        Token token = Token.fromJson(json.decode(strToken ?? ''));
        request.headers['Authorization'] = 'Bearer ${token.accessToken}';
      }
    }
    return client.send(request);
  }

  bool _requiresTokenAuthentication(String url) {
    return PublicEndpoints.endpoints.any((endpoint) => url == endpoint);
  }
}
