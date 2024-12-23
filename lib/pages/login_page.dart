import 'package:flutter/material.dart';
import 'package:superbase_project/auth/auth_service.dart';
import 'package:superbase_project/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //get auth service
  final authService = AuthService();

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //login button pressed
  void login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    //attempt to login
    try {
      await authService.signInWithEmail(email, password);
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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: login,
            child: const Text("Login"),
          ),
          const SizedBox(height: 16),
          //go to register page to sign up
          GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage())),
              child: Center(child: Text("Don't have an account? Sign up"))),
        ],
      ),
    );
  }
}
