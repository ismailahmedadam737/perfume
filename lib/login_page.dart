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
        print("DEBUG: API Response: $responseData");
        
        String userRole = 'user'; 

        // SAFE LOGIC: Waxaan baaraynaa labada meelood ee role-ku ku jiri karo
        if (responseData is Map) {
          // 1. Haddii uu ku jiro 'user' object (sida: {user: {role: admin}})
          if (responseData.containsKey('user') && responseData['user'] is Map) {
            userRole = (responseData['user']['role'] ?? 'user').toString();
          } 
          // 2. Haddii uu toos ugu jiro (sida: {role: admin})
          else {
            userRole = (responseData['role'] ?? 'user').toString();
          }
        } 
        // 3. Haddii uu yahay List
        else if (responseData is List && responseData.isNotEmpty) {
          var firstItem = responseData[0];
          if (firstItem is Map) {
            userRole = (firstItem['role'] ?? 'user').toString();
          }
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
        _showSnackBar("Email ama Password khaldan ama server-ka ayaa diiday!");
      }
    } catch (e) {
      _showSnackBar("Khalad ayaa dhacay: $e");
      print("Error: $e");
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
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
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