import 'package:http/http.dart' as http;
import 'package:validator/domain/entities/token.dart';

class TokenInterceptorTest extends http.BaseClient {
  final http.Client client;
  final Token token;

  TokenInterceptorTest({required this.client, required this.token});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = 'Bearer ${token.accessToken}';
    return client.send(request);
  }
}
