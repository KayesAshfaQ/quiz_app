import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/app_route.dart';

import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage!)));
          });
        } 

        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                ElevatedButton(
                  onPressed: _onPressedLogin,
                  child: const Text('Login'),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Navigate to signup page
                    context.push(AppRoute.signup);
                  },
                  child:  authProvider.isLoading
                      ? CircularProgressIndicator()
                      : const Text('Don\'t have an account? Sign Up'),
                ),

                 SizedBox(height: 16),

                 // button to sigin in with Google
                  ElevatedButton(
                    onPressed: () {
                      // Call Google sign-in logic here, e.g. using AuthProvider
                      context.read<AuthProvider>().loginWithGoogle();
                    },
                    child: authProvider.isLoading
                        ? CircularProgressIndicator()
                        : const Text('Sign in with Google'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onPressedLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    // Call login logic here, e.g. using AuthProvider
    context.read<AuthProvider>().login(email, password);
  }
}
