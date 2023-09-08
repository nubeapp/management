import 'dart:convert';

import 'package:validator/config/app_config.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:http/http.dart' as http;
import 'package:validator/domain/services/organization_service_interface.dart';
import 'package:validator/presentation/styles/logger.dart';

class OrganizationService implements IOrganizationService {
  OrganizationService({required this.client});

  final http.Client client;
  static String get API_BASE_URL => 'http://$LOCALHOST:8000/organizations';

  @override
  Future<List<Organization>> getOrganizations() async {
    try {
      Logger.debug('Requesting all organizations to the database...');
      final response = await client.get(Uri.parse(API_BASE_URL));
      if (response.statusCode == 200) {
        Logger.info('Organizations have been retrieved successfully!');
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Organization.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get organizations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Organization> getOrganizationById(int organizationId) async {
    try {
      Logger.debug('Requesting organization with id $organizationId...');
      final response = await client.get(Uri.parse('$API_BASE_URL/$organizationId'));
      if (response.statusCode == 200) {
        Logger.info('Organization has been retrieved successfully!');
        final Map<String, dynamic> data = json.decode(response.body);
        return Organization.fromJson(data);
      } else {
        throw Exception('Failed to get organization. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Organization> createOrganization(Organization organization) async {
    try {
      Logger.debug('Creating organization...');
      final response = await client.post(Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(organization.toJson()));
      if (response.statusCode == 201) {
        Logger.info('Organization has been created successfully!');
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return Organization.fromJson(data);
      } else {
        throw Exception('Failed to create organization. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteOrganizationById(int organizationId) async {
    try {
      Logger.debug('Deleting organization with id $organizationId...');
      final response = await client.delete(Uri.parse('$API_BASE_URL/$organizationId'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete organization by id. Status code: ${response.statusCode}');
      }

      Logger.info('Organization with id $organizationId has been deleted successfully!');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteOrganizations() async {
    try {
      Logger.debug('Deleting all organizations from the database...');
      final response = await client.delete(Uri.parse(API_BASE_URL));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete users');
      }
      Logger.info('All users have been deleted successfully');
    } catch (e) {
      rethrow;
    }
  }
}
