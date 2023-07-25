import 'package:http/http.dart' as http;
import 'token_interceptor.dart';

class HttpClient extends http.BaseClient {
  final TokenInterceptor interceptor;

  HttpClient({required this.interceptor});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return interceptor.send(request);
  }
}

class HttpClientFactory {
  static http.Client create() {
    final tokenInterceptor = TokenInterceptor(client: http.Client());
    final httpClient = HttpClient(interceptor: tokenInterceptor);
    return httpClient;
  }
}
