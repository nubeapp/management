import 'package:http/http.dart' as http;
import 'package:validator/domain/entities/token.dart';
import 'token_interceptor_test.dart';

class HttpClientTest extends http.BaseClient {
  final TokenInterceptorTest interceptor;

  HttpClientTest({required this.interceptor});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return interceptor.send(request);
  }
}

class HttpClientFactoryTest {
  static http.Client create(Token token) {
    final tokenInterceptor = TokenInterceptorTest(client: http.Client(), token: token);
    final httpClient = HttpClientTest(interceptor: tokenInterceptor);
    return httpClient;
  }
}
