import 'package:flutter/material.dart';

import '../navigation/app_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Registration is handled externally for now.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
