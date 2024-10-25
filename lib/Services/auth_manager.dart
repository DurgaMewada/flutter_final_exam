
import 'package:flutter/material.dart';

import '../view/home_screen.dart';
import '../view/signIn_screen.dart';
import 'auth_service.dart';





class AuthManager extends StatelessWidget {
  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    return (AuthService.authService.getUser() == null)
        ?  SignIn()
        :  HomeScreen();
  }
}