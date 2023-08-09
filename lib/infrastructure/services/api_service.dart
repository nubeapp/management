import 'package:http/http.dart' as http;
import 'package:validator/config/app_config.dart';
import 'package:validator/domain/services/api_service_interface.dart';
import 'package:validator/presentation/styles/logger.dart';

class ApiService implements IApiService {
  ApiService({required this.client});

  static String get API_BASE_URL => 'http://$LOCALHOST:8000/';
  final http.Client client;

  @override
  Future<String> connectAPI() async {
    try {
      final response = await client.get(Uri.parse(API_BASE_URL));
      if (response.statusCode == 200) {
        Logger.info('Server is running...');
        return 'Server is running...';
      } else {
        throw Exception('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
