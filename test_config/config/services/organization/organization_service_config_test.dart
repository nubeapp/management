import 'package:get_it/get_it.dart';
import '../../config_test.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/services/organization_service_interface.dart';

class OrganizationServiceConfigTest extends ConfigTest {
  late IOrganizationService _organizationService;
  late final int _mockOrganizationId;
  late final Organization _mockOrganization;

  int get mockOrganizationId => _mockOrganizationId;
  Organization get mockOrganization => _mockOrganization;

  Future<IOrganizationService> setUpDatabase() async {
    await super.setUpBaseDatabase();
    _organizationService = GetIt.instance<IOrganizationService>();

    _mockOrganization = const Organization(name: 'test organization');

    Organization organization = await _organizationService.createOrganization(_mockOrganization);
    _mockOrganizationId = organization.id!;

    return _organizationService;
  }

  Future<void> cleanUpDatabase() async {
    await super.cleanUpBaseDatabase();
    await _organizationService.deleteOrganizations();
  }
}
