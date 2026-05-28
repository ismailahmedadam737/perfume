import 'package:flutter/material.dart';
import 'package:perfume/services/user_service.dart';
import 'package:perfume/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Function-ka asalka ahaa ee Login-ka
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Fadlan geli email-ka iyo password-ka");
      return;
    }

    setState(() => _isLoading = true);

    try {
      var responseData = await UserService.loginUser(email, password);

      if (responseData != null) {
        // Waxaan u qaadanaynaa role-ka sidii aan horey u saxnay (user object gudahiisa)
        String userRole = 'user';
        if (responseData is Map && responseData.containsKey('user')) {
           userRole = responseData['user']['role'].toString();
        } else if (responseData is Map) {
           userRole = responseData['role']?.toString() ?? 'user';
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(role: userRole.trim().toLowerCase()),
            ),
          );
        }
      } else {
        _showSnackBar("Login failed: Email ama Password khaldan");
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    // UI-ga asalka ahaa
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 80, color: Colors.purple),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                      child: const Text("LOGIN"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}