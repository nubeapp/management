import 'package:flutter/material.dart';

@immutable
class User {
  final int? id;
  final String name;
  final String email;
  final String surname;
  final String? password;

  const User({
    this.id,
    required this.email,
    required this.name,
    required this.surname,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      surname: json['surname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'password': password,
    };
  }
}
