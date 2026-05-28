import 'package:flutter/material.dart';
import 'package:perfume/services/user_service.dart'; 
import 'main.dart'; // Hubi in HomePage uu ku jiro main.dart ama import sax ah

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
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

      if (responseData != null) {
        // Halkan ayaan ka soo saaraynaa role-ka si sax ah
        String userRole = 'user'; 
        
        if (responseData.containsKey('role')) {
          userRole = responseData['role'].toString();
        } else if (responseData.containsKey('user') && responseData['user'] is Map) {
          userRole = responseData['user']['role'].toString();
        }

        print("DEBUG: Final Role identified: $userRole");

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(role: userRole.trim().toLowerCase()),
            ),
          );
        }
      } else {
        _showSnackBar("Email ama Password khaldan!");
      }
    } catch (e) {
      _showSnackBar("Khalad ayaa dhacay, hubi internetka!");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E2D), Color(0xFF6A11CB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.lock_person_rounded, size: 60, color: Colors.pinkAccent),
                  const SizedBox(height: 20),
                  const Text("PERFUME LOGIN", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(hintText: "Email", hintStyle: TextStyle(color: Colors.white54), prefixIcon: Icon(Icons.email, color: Colors.white70)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _isLoading 
                    ? const CircularProgressIndicator(color: Colors.pinkAccent)
                    : ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, minimumSize: const Size(double.infinity, 50)),
                        child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}