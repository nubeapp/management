import 'package:flutter/material.dart';

@immutable
class Organization {
  final int? id;
  final String name;

  // Constructor
  const Organization({
    this.id,
    required this.name,
  });

  // Factory method to create a new instance from a Map (fromJson)
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      name: json['name'],
    );
  }

  // Method to convert the instance to a Map (toJson)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
