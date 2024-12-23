import 'package:flutter/material.dart';
import 'package:superbase_project/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //get auth service
  final authService = AuthService();

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //register button pressed
  void signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    //check if passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    Navigator.pop(context);

    //attempt to register
    try {
      await authService.signUpWithEmail(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            controller: _passwordController,
            //obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
          ),
          TextField(
            controller: _confirmPasswordController,
            //obscureText: true,
            decoration: const InputDecoration(
              labelText: "Confirm Password",
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: signUp,
            child: const Text("Sign Up"),
          ),
          const SizedBox(height: 16),
          //go to register page to sign up
        ],
      ),
    );
  }
}
