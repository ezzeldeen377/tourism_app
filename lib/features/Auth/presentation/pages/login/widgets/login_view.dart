import 'package:flutter/material.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Login(),
    );
  }
}
