import 'package:flutter/material.dart';
import 'package:validator/domain/entities/credentials.dart';
import 'package:validator/domain/entities/token.dart';

@immutable
abstract class IAuthService {
  Future<Token> login(Credentials credentials);
}
