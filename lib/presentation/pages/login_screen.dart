import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validator/domain/entities/credentials.dart';
import 'package:validator/domain/entities/token.dart';
import 'package:validator/domain/services/auth_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/pages/pages.dart';
import 'package:validator/presentation/widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = GetIt.instance<IAuthService>();
  late SharedPreferences _sharedPreferences;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _sharedPreferences = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.black54)
            : Button.black(
                text: 'Log in',
                width: context.w * 0.4,
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });

                  Token token = await _authService.login(const Credentials(username: 'alvarolopsi@gmail.com', password: 'alvarolopsi'));
                  await _sharedPreferences.setString('token', json.encode(token.toJson()));

                  setState(() {
                    _isLoading = false;
                  });

                  Navigator.of(context).push(MaterialPageRoute(
                    settings: const RouteSettings(name: '/main_screen'),
                    builder: (context) => const MainScreen(),
                  ));
                },
              ),
      ),
    );
  }
}

class LoginBloc {
  final _authService = GetIt.instance<IAuthService>();
  final _loadingController = StreamController<bool>.broadcast();

  Stream<bool> get isLoadingStream => _loadingController.stream;

  Future<void> login() async {
    _loadingController.add(true);
    Token token = await _authService.login(const Credentials(username: 'alvarolopsi@gmail.com', password: 'alvarolopsi'));
    await _saveTokenToSharedPreferences(token.toJson());
    _loadingController.add(false);
  }

  Future<void> _saveTokenToSharedPreferences(Map<String, dynamic> tokenData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', json.encode(tokenData));
  }

  void dispose() {
    _loadingController.close();
  }
}
