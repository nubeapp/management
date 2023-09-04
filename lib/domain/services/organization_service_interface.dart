import 'package:flutter/material.dart';
import 'package:validator/domain/entities/organization.dart';

@immutable
abstract class IOrganizationService {
  Future<List<Organization>> getOrganizations();
  Future<Organization> getOrganizationById(int organizationId);
  Future<Organization> createOrganization(Organization organization);
  Future<void> deleteOrganizations();
}
