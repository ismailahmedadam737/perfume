import 'package:flutter/material.dart';
import 'package:perfume/services/user_service.dart';
import 'package:perfume/main.dart'; // Hubi inuu yahay path-ka HomePage-kaaga

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

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

      if (responseData != null && responseData['success'] == true) {
        // Halkan waxaan ka soo saaraynaa role-ka sida server-ku u soo diray
        String userRole = 'user';
        if (responseData.containsKey('user')) {
          userRole = responseData['user']['role']?.toString().toLowerCase().trim() ?? 'user';
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(role: userRole),
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