import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/services/organization_service_interface.dart';
import 'package:validator/presentation/styles/logger.dart';

class OrganizationDropdown extends StatefulWidget {
  const OrganizationDropdown({required this.organizationSelected, super.key});
  final Organization organizationSelected;

  @override
  State<OrganizationDropdown> createState() => _OrganizationDropdownState();
}

class _OrganizationDropdownState extends State<OrganizationDropdown> {
  final IOrganizationService _organizationService = GetIt.instance<IOrganizationService>();
  List<Organization> _options = [];
  Organization? _selectedOption;

  @override
  void initState() {
    super.initState();
    _organizationService.getOrganizations().then((organizations) {
      setState(() {
        _options = organizations;
        // Search for the organization in the list
        _selectedOption = _options.firstWhere((organization) => organization.id == widget.organizationSelected.id);
      });
    }).catchError((error) {
      Logger.error(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Organization>(
      value: _selectedOption,
      onChanged: (newValue) {
        setState(() {
          _selectedOption = newValue;
        });
      },
      items: _options.map(
        (organization) {
          return DropdownMenuItem<Organization>(
            value: organization,
            child: Text(organization.name),
          );
        },
      ).toList(),
      isExpanded: true,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w500,
      ),
      borderRadius: BorderRadius.circular(15),
      icon: const Icon(CupertinoIcons.chevron_down),
      iconSize: 20,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 17, bottom: 17, left: 15, right: 15),
        hintText: 'Universal Music Spain',
        hintStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.7,
          color: Colors.black.withOpacity(0.3),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 240, 240),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
